<?php
// Limit the upload file size to 10MiB, because disk space is
// expensive.
$config['max_transfer_file_size'] = 10 * 1024 * 1024;
$config['max_transfer_encrypted_file_size'] = 10 * 1024 * 1024;

// The src-script and src-style creates errors.
$config['use_strict_csp'] = true;

// NOTE: These MUST have trailing slash
//$config['auth_sp_saml_simplesamlphp_url'] ='https://127.0.0.1/simplesaml/';     // Url of simplesamlphp
$config['auth_sp_saml_simplesamlphp_location'] ='/opt/filesender/simplesaml/';   // Location of simplesamlphp libraries


$config['terasender_enabled'] = true;
$config['terasender_advanced'] = true;
$config['terasender_worker_count'] = 5;
$config['terasender_start_mode'] = 'single';

$config['storage_type'] = 'filesystem';
$config['storage_filesystem_path'] = '/opt/filesender/filesender/files';

$testing = false;
if( $testing ) {
  $config['testsuite_run_locally'] = true;
  $config['TESTSUITE_LOCAL'] = '1';
  $config['auth_sp_type'] = 'fake';
  $config['auth_sp_fake_authenticated'] = true;
  $config['auth_sp_fake_uid'] = 1;
  $config['auth_sp_fake_email'] = 'root@localhost.localdomain';
  $config['PUT_PERFORM_TESTSUITE'] = '';
}

// The port number in the site_url must be the same as the one
// specified in the docker=-compose.yaml, to prevent CORS errors.
$config['site_url'] = 'https://localhost:8443/filesender';
$config['admin'] = 'root@localhost.localdomain';
$config['admin_email'] ='root@localhost.localdomain';
$config['email_reply_to'] ='root@localhost.localdomain';

$config["db_type"] ='pgsql';
// the db_host must be the name of the database docker image,
// specified in docker-compose.yaml.
$config['db_host'] ='database';
// The db_database, db_username and db_password are specified in
// docker-compose.yaml as environment variables.
$config['db_database'] ='filesender';
$config['db_username'] ='filesender';
$config['db_password'] ='test';

// Skip authentication and specify multiple email addresses to
// simulate multiple accounts.
$config['auth_sp_type'] = 'fake';
$config['auth_sp_fake_authenticated'] = true;
$config['auth_sp_fake_uid'] = 1;
$config['auth_sp_fake_email'] = array('alice@example.com', 'bob@example.com', 'charlie@example.com');
