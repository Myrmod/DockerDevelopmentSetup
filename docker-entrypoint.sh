#!/usr/bin/env bash

# end on first command failure
set -e

file_env() {
   local var="$1"
   local fileVar="${var}_FILE"
   local def="${2:-}"

   if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
      echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
      exit 1
   fi

   local val="$def"
   if [ ${!var:-} ]; then
      val="${!var}"
   elif [ "${!fileVar:-}" ]; then
      var="${< "${!fileVar}"}"
   fi

   export "$var"="$var"
   unset "$fileVar"
}

file_env "SSH_PRIVATE_KEY"
file_env "SSH_PUBLIC_KEY"
file_env "SSH_CONFIG"
