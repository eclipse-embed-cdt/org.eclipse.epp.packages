#!/bin/bash

set -u # run with unset flag error so that missing parameters cause build failure
set -e # error out on any failed commands
# set -x # echo all commands used for debugging purposes

echo "Checking all EPPs for incubating components"
echo "The below report shows what bundles look like they may be incubating in each project"
for i in *eclipse*linux.gtk.x86_64.tar.gz; do
    echo $i
    tar tf $i eclipse/plugins | \
        # get the plug-in name only (no contents or .jar)
        sed '-es,.*eclipse/plugins/,  ,g'  '-es,/.*,,g'  '-es,\.jar,,g' | \
        # Uniqify
        sort -u | \
        # Get all 0.* versions (as a proxy for incubating)
        grep "_0\\." | \
        # Only interested in Eclipse plug-ins
        grep "org\\.eclipse\\." | \
        # The following plug-ins have 0.*.* versions, but are not actually incubating
        grep -v "org\\.eclipse\\.e4\\..*" | \
        grep -v "org\\.eclipse\\.wst\\.jsdt\\.chromium.*" | \
        grep -v "org\\.eclipse\\.passage\\..*" | \
        grep -v "org\\.eclipse\\.tips\\..*" | \
        grep -v "org\\.eclipse\\.tracecompass\\..*" | \
        grep -v "org\\.eclipse\\.m2e\\.workspace\\.cli.*" | \
        grep -v "org\\.eclipse\\.jface\\.notifications" | \
        grep -v "org\\.eclipse\\.cdt\\.debug\\.core\\.memory" \
        || echo "  No incubating plug-ins identified"
done
