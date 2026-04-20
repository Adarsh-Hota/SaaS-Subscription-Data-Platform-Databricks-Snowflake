CREATE OR REPLACE CATALOG INTEGRATION databricks_unity_catalog_integration
  CATALOG_SOURCE = ICEBERG_REST
  TABLE_FORMAT = ICEBERG
  CATALOG_NAMESPACE = 'gold'
  REST_CONFIG = (
    CATALOG_URI = '<databricks_catalog_uri>'
    CATALOG_NAME = '<databricks_catalog_name>'
    ACCESS_DELEGATION_MODE = VENDED_CREDENTIALS
  )
  REST_AUTHENTICATION = (
    TYPE = OAUTH
    OAUTH_TOKEN_URI = '<databricks_oauth_token_uri>'
    OAUTH_CLIENT_ID = '<databricks_oauth_client_id>'
    OAUTH_CLIENT_SECRET = '<databricks_oauth_client_secret>'
    OAUTH_ALLOWED_SCOPES = ('all-apis', 'sql')
  )
  ENABLED = TRUE;
