#!/bin/bash
/opt/app/prod/rel/rush/bin/rush eval "Rush.Utils.Releases.migrate()" 

/opt/app/prod/rel/rush/bin/rush eval "Rush.Utils.Releases.update_rushing()" 


echo "Starting Application"
/opt/app/prod/rel/rush/bin/rush start 