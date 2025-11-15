#!/bin/sh
# Name: KNotes
# Author: Kurizu
# DontUseFBInk

# Modified Version Of Illusion By Penguins184, For Less Tampering With VAR/LOCAL.

APP_ID="xyz.kurizu.knotes"
SOURCE_DIR="/mnt/us/documents/KNotes"
DB="/var/local/appreg.db"

BIN_HF="$SOURCE_DIR/assets/UtildHF"
BIN_SF="$SOURCE_DIR/assets/UtildSF"

if [ -e /lib/ld-linux-armhf.so.3 ]; then
    BINARY="$BIN_HF"
else
    BINARY="$BIN_SF"
fi

if [ -x "$BINARY" ]; then
    "$BINARY"
elif [ -e "$BINARY" ]; then
    chmod +x "$BINARY"
    "$BINARY"
fi

sqlite3 "$DB" <<EOF
INSERT OR IGNORE INTO interfaces(interface) VALUES('application');
INSERT OR IGNORE INTO handlerIds(handlerId) VALUES('$APP_ID');
INSERT OR REPLACE INTO properties(handlerId,name,value) VALUES('$APP_ID','lipcId','$APP_ID');
INSERT OR REPLACE INTO properties(handlerId,name,value) VALUES('$APP_ID','command','/usr/bin/mesquite -l $APP_ID -c file://$SOURCE_DIR/');
INSERT OR REPLACE INTO properties(handlerId,name,value) VALUES('$APP_ID','supportedOrientation','U');
EOF

echo "Registered $APP_ID. You may now launch it via LIPC."
sleep 2

nohup lipc-set-prop com.lab126.appmgrd start app://$APP_ID >/dev/null 2>&1 &
