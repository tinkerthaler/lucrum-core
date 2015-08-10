## Prerequisites

   brew install postgresql92

Caveats (from brew)
initdb /usr/local/var/postgres -E utf8    # create a database
postgres -D /usr/local/var/postgres       # serve that database
PGDATA=/usr/local/var/postgres postgres   # ...alternatively

To have launchd start homebrew/versions/postgresql92 at login:

    ln -sfv /usr/local/opt/postgresql92/*.plist ~/Library/LaunchAgents

Then to load homebrew/versions/postgresql92 now:

    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql92.plist

Or, if you don't want/need launchctl, you can just run:

    pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start

Connect to the database

    psql postgres

Create roles

    CREATE ROLE lucrum_admin LOGIN;
    CREATE ROLE lucrum_user LOGIN;

Manage the database

    postgres=# SELECT datname FROM pg_database;

Output: 

      datname
    -----------
     template1
     template0
     postgres
    (3 rows)