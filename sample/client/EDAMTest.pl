use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../../lib";

use IO::File;
use Digest::MD5;
use Data::Dumper;
use Scalar::Util qw( blessed );
use Exception::Class (
    'EDAMTest::Exception::ExceptionWrapper',
    'EDAMTest::Exception::FileIOError',
);

use LWP::Protocol::https; # it is not needed to 'use' here, but it must be installed.
        # if it is not installed, an error (Thrift::TException object) is to be thrown.
use Thrift::HttpClient;
use Thrift::BinaryProtocol;
use EDAMTypes::Types;  # you must do `use' EDAMTypes::Types and EDAMErrors::Types
use EDAMErrors::Types; # before doing `use' EDAMUserStore::UserStore or EDAMNoteStore::NoteStore
use EDAMUserStore::UserStore;
use EDAMNoteStore::NoteStore;
use EDAMUserStore::Constants;

# Real applications authenticate with Evernote using OAuth, but for the
# purpose of exploring the API, you can get a developer token that allows
# you to access your own Evernote account. To get a developer token, visit
# https://sandbox.evernote.com/api/DeveloperToken.action
my $auth_token = 'your developer token';

if ( $auth_token eq 'your developer token' ) {
    print "Please fill in your developer token\n";
    print "To get a developer token, " .
          "visit https://sandbox.evernote.com/api/DeveloperToken.action\n";
    exit 1;
}

eval {
    # any exception occured in this eval block is Exception::Class::Base object.
    # if other is thrown, it is to be wrapped in EDAMTest::Exception::ExceptionWrapper.
    local $SIG{__DIE__} = sub {
        my ( $err ) = @_;
        if ( not ( blessed $err && $err->isa('Exception::Class::Base') ) ) {
            EDAMTest::Exception::ExceptionWrapper->throw( error => $err );
        }
    };

    my $evernote_host = 'sandbox.evernote.com';
    my $user_store_url = 'https://' . $evernote_host . '/edam/user';

    my $user_store_client = Thrift::HttpClient->new( $user_store_url );
    # default timeout value may be too short
    $user_store_client->setSendTimeout( 2000 );
    $user_store_client->setRecvTimeout( 10000 );
    my $user_store_prot = Thrift::BinaryProtocol->new( $user_store_client );
    my $user_store = EDAMUserStore::UserStoreClient->new( $user_store_prot, $user_store_prot );

    my $version_ok = $user_store->checkVersion( 'Evernote EDAMTest (Perl)',
        EDAMUserStore::Constants::EDAM_VERSION_MAJOR,
        EDAMUserStore::Constants::EDAM_VERSION_MINOR );
    printf "Is my Evernote API version up to date?: %s\n", $version_ok ? 'yes' : 'no';
    if ( not $version_ok ) {
        exit(1)
    }

    my $note_store_url = $user_store->getNoteStoreUrl( $auth_token );

    warn '[INFO] note store url : ' . $note_store_url;
    my $note_store_client = Thrift::HttpClient->new( $note_store_url );
    # default timeout value may be too short
    $note_store_client->setSendTimeout( 2000 );
    $note_store_client->setRecvTimeout( 10000 );
    my $note_store_prot = Thrift::BinaryProtocol->new( $note_store_client );
    my $note_store = EDAMNoteStore::NoteStoreClient->new( $note_store_prot, $note_store_prot );

    # List all of the notebooks in the user's account
    my $notebooks = $note_store->listNotebooks( $auth_token ); # ARRAY of EDAMTypes::Notebook objects

    printf "Found %d notebooks:\n", scalar(@$notebooks);
    my $default_notebook = $notebooks->[0];
    for my $notebook ( @$notebooks ) {
        printf "  * %s\n", $notebook->name;
    }

    print "\n";
    printf "Creating a new note in the default notebook: %s\n", $default_notebook->name;
    print "\n";

    # To create a new note, simply create a new Note object and fill in
    # attributes such as the note's title.
    my $note = EDAMTypes::Note->new();
    $note->title( "Test note from test.pl" );

    # To include an attachment such as an image in a note, first create a Resource
    # for the attachment. At a minimum, the Resource contains the binary attachment
    # data, an MD5 hash of the binary data, and the attachment MIME type. It can also
    #/ include attributes such as filename and location.
    my $filename = $FindBin::Bin . "/enlogo.png";
    my $image_bin = do {
        my $iof = IO::File->new( $filename, '<' )
            or EDAMTest::Exception::FileIOError->throw( "file open failed: $filename" );
        $iof->binmode( ':bytes' );
        do { local $/; <$iof> };
    };

    my $data = EDAMTypes::Data->new();
    $data->size( length $image_bin );
    $data->bodyHash( Digest::MD5::md5( $image_bin ) );
    $data->body( $image_bin );

    my $resource = EDAMTypes::Resource->new();
    $resource->mime( "image/png" );
    $resource->data( $data );
    $resource->attributes( EDAMTypes::ResourceAttributes->new() );
    $resource->attributes->fileName( $filename );

    # Now, add the new Resource to the note's list of resources
    $note->resources( [ $resource ] );

    # To display the Resource as part of the note's content, include an <en-media>
    # tag in the note's ENML content. The en-media tag identifies the corresponding
    # Resource using the MD5 hash.
    my $hash_hex = Digest::MD5::md5_hex( $image_bin );

    # The content of an Evernote note is represented using Evernote Markup Language
    # (ENML). The full ENML specification can be found in the Evernote API Overview
    # at http://dev.evernote.com/documentation/cloud/chapters/ENML.php
    $note->content( '<?xml version="1.0" encoding="UTF-8"?>' .
      '<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">' .
      '<en-note>Here is the Evernote logo:<br/>' .
      '<en-media type="image/png" hash="' . $hash_hex . '"/>' .
      '</en-note>' );

    # Finally, send the new note to Evernote using the createNote method
    # The new Note object that is returned will contain server-generated
    # attributes such as the new note's unique GUID.
    my $created_note = $note_store->createNote( $auth_token, $note );

    printf "Successfully created a new note with GUID: %s\n", $created_note->guid;
};
if ( my $err = $@ ) {
    print STDERR "[ERROR]\n";
    if ( blessed $err->error ) {
        print STDERR "=== Error object ===\n";
        local $Data::Dumper::Indent = 1;
        print STDERR Dumper( $err->error );
    } else {
        print STDERR "=== Error message ===\n";
        print STDERR $err->error, "\n";
    }
    print STDERR "=== Stack trace ===\n";
    print STDERR $err->trace->as_string;
    exit 1;
}
