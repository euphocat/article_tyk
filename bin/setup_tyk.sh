#! /bin/bash

# This script will set up a full tyk environment on your machine
# and also create a demo user for you with one command

# USAGE
# -----
#
# $> ./tyk_quickstart.sh {IP ADDRESS OF DOCKER VM}

# OSX users will need to specify a virtual IP, linux users can use 127.0.0.1

TYK_DASHBOARD="tyk_dashboard.tyk_dashboard.docker"
TYK_API="api.local"

if [ -n "$1" ]
then
    TYK_DASHBOARD=$1
    echo "Docker host address explicitly set."
    echo "Using $TYK_DASHBOARD as Tyk dashboard host address."
fi

if [ -n "$2" ]
then
    TYK_API=$2
    echo "Docker portal TYK_API address explicitly set."
    echo "Using $TYK_API as Tyk API host address."
fi

if [ -z "$1" ]
then
        echo "Using $TYK_DASHBOARD as Tyk host address."
#        echo "If this is wrong, please specify the instance IP address (e.g. ./setup.sh 192.168.1.1)"
fi

RANDOM_USER="admin"
PASS="test123"

echo "Creating Organisation"
ORGDATA=$(curl --silent --header "admin-auth: 12345" --header "Content-Type:application/json" --data '{"owner_name": "TestOrg5 Ltd.","owner_slug": "testorg", "cname_enabled":true}' http://$TYK_DASHBOARD:3000/admin/organisations 2>&1)
#echo $ORGDATA
ORGID=$(echo $ORGDATA | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["Meta"]')
echo "ORGID: $ORGID"

echo "Adding new user"
USER_DATA=$(curl --silent --header "admin-auth: 12345" --header "Content-Type:application/json" --data '{"first_name": "John","last_name": "Smith","email_address": "'$RANDOM_USER'@test.com","active": true,"org_id": "'$ORGID'"}' http://$TYK_DASHBOARD:3000/admin/users 2>&1)
#echo $USER_DATA
USER_CODE=$(echo $USER_DATA | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["Message"]')
echo "USER AUTH: $USER_CODE"

USER_LIST=$(curl --silent --header "authorization: $USER_CODE" http://$TYK_DASHBOARD:3000/api/users 2>&1)
#echo $USER_LIST

USER_ID=$(echo $USER_LIST | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["users"][0]["id"]')
echo "NEW ID: $USER_ID"

echo "Setting password"
OK=$(curl --silent --header "authorization: $USER_CODE" --header "Content-Type:application/json" http://$TYK_DASHBOARD:3000/api/users/$USER_ID/actions/reset --data '{"new_password":"'$PASS'"}')

echo "Create Open API"

read -d '' DATA <<EOF
{
    "api_definition": {
      "id": "568c240f5c79a20001000002",
      "name": "Open API",
      "slug": "open",
      "api_id": "8028f38838ec4f4867693c12921c637e",
      "org_id": "568c240f5c79a20001000001",
      "use_keyless": true,
      "use_oauth2": false,
      "oauth_meta": {
          "allowed_access_types": [],
          "allowed_authorize_types": [],
          "auth_login_redirect": ""
      },
      "auth": {
          "use_param": false,
          "use_cookie": false,
          "auth_header_name": ""
      },
      "use_basic_auth": false,
      "enable_jwt": false,
      "jwt_signing_method": "",
      "notifications": {
          "shared_secret": "",
          "oauth_on_keychange_url": ""
      },
      "enable_signature_checking": false,
      "hmac_allowed_clock_skew": -1,
      "definition": {
          "location": "header",
          "key": "x-api-version"
      },
      "version_data": {
          "not_versioned": true,
          "versions": {
              "Default": {
                  "name": "Default",
                  "expires": "",
                  "paths": {
                      "ignored": [],
                      "white_list": [],
                      "black_list": []
                  },
                  "use_extended_paths": true,
                  "extended_paths": {
                      "ignored": [],
                      "white_list": [],
                      "black_list": [],
                      "cache": [],
                      "transform": [],
                      "transform_response": [],
                      "transform_headers": [],
                      "transform_response_headers": [],
                      "hard_timeouts": [],
                      "circuit_breakers": [],
                      "url_rewrites": [],
                      "virtual": [],
                      "size_limits": []
                  },
                  "global_headers": {},
                  "global_headers_remove": [],
                  "global_size_limit": 0
              }
          }
      },
      "uptime_tests": {
          "check_list": [],
          "config": {
              "expire_utime_after": 0,
              "service_discovery": {
                  "use_discovery_service": false,
                  "query_endpoint": "",
                  "use_nested_query": false,
                  "parent_data_path": "",
                  "data_path": "",
                  "port_data_path": "",
                  "use_target_list": false,
                  "cache_timeout": 0,
                  "endpoint_returns_list": false
              },
              "recheck_wait": 0
          }
      },
      "proxy": {
          "listen_path": "/open/",
          "target_url": "http://bouchon.local",
          "strip_listen_path": true,
          "enable_load_balancing": false,
          "target_list": [],
          "check_host_against_uptime_tests": false,
          "service_discovery": {
              "use_discovery_service": false,
              "query_endpoint": "",
              "use_nested_query": false,
              "parent_data_path": "",
              "data_path": "",
              "port_data_path": "",
              "use_target_list": false,
              "cache_timeout": 0,
              "endpoint_returns_list": false
          }
      },
      "custom_middleware": {
          "pre": [],
          "post": [],
          "response": []
      },
      "cache_options": {
          "cache_timeout": 1000,
          "enable_cache": true,
          "cache_all_safe_requests": true,
          "enable_upstream_cache_control": false
      },
      "session_lifetime": 0,
      "active": true,
      "auth_provider": {
          "name": "",
          "storage_engine": "",
          "meta": {}
      },
      "session_provider": {
          "name": "",
          "storage_engine": "",
          "meta": null
      },
      "event_handlers": {
          "events": {}
      },
      "enable_batch_request_support": false,
      "enable_ip_whitelisting": false,
      "allowed_ips": [],
      "dont_set_quota_on_create": false,
      "expire_analytics_after": 0,
      "response_processors": [],
      "CORS": {
          "enable": true,
          "allowed_origins": [],
          "allowed_methods": [],
          "allowed_headers": [
              "Authorization"
          ],
          "exposed_headers": [],
          "allow_credentials": false,
          "max_age": 0,
          "options_passthrough": false,
          "debug": false
      },
      "domain": "",
      "do_not_track": false,
      "tags": []
    },
    "api_model": {},
    "hook_references": []
}
EOF

CREATED_API_RESPONSE=$(curl -s -H "authorization: $USER_CODE" -X POST -d "$DATA" -H "Content-Type: application/json" http://$TYK_DASHBOARD:3000/api/apis 2>&1)
#echo $CREATED_API_RESPONSE
CREATED_API_ID=$(echo $CREATED_API_RESPONSE | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["Meta"]')
echo "API ID: $CREATED_API_ID"

echo "Read created API"
API_DATA=$(curl -s -H "authorization: $USER_CODE" -X GET -d "$DATA" -H "Content-Type: application/json" http://$TYK_DASHBOARD:3000/api/apis/$CREATED_API_ID 2>&1)
#echo $API_DATA

# Replace random listen_path by /open/
UPDATE_API_DATA=$(echo $API_DATA | sed 's/"listen_path":"\/[a-z0-9]*\/"/"listen_path":"\/open\/"/g' 2>&1)

#echo $UPDATE_API_DATA

echo "Update 'listen_path'"
UPDATE_DATA=$(curl -s -H "authorization: $USER_CODE" -X PUT -d "$UPDATE_API_DATA" -H "Content-Type: application/json" http://$TYK_DASHBOARD:3000/api/apis/$CREATED_API_ID 2>&1)
#echo $UPDATE_DATA

echo -e "\n"

echo "DONE"
echo "===="
echo "Login at http://$TYK_API:3000/"
echo "User: $RANDOM_USER@test.com"
echo "Pass: $PASS"
echo ""
