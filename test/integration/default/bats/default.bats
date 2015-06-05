#!/usr/bin/env bats
# vi: se ft=sh:

@test "solr link exists" {
    run test -L /opt/solr
    [ $status -eq 0 ]
}

@test "solr link target exists" {
    run test -e /opt/solr
    [ $status -eq 0 ]
}

@test "solr ZK_HOST is set" {
    run grep '^ZK_HOST="[^ ]\+"' /var/solr/solr.in.sh
    [ $status -eq 0 ]
}

@test "zookeeper link exists" {
    run test -L /opt/zookeeper
    [ $status -eq 0 ]
}

@test "zookeeper link target exists" {
    run test -e /opt/zookeeper
    [ $status -eq 0 ]
}

@test "At least 3 zookeeper nodes are configured" {
    num=`grep -E  "server.[0-9]+=" /opt/zookeeper/conf/zoo.cfg| wc -l`
    [ "$num" -ge "3" ]
}

@test "solr listens on port 8987" {
    run curl -k  http://localhost:8987
    [ $status -eq 0 ]
}

@test "Firewall allows traffic to solr port from from a fixture node" {
    run egrep "^### tuple ### allow tcp 8987 0.0.0.0/0 any 10.0.1.9 in" /lib/ufw/user.rules
    [ "$status" -eq 0 ]
}

# Skip testing that zookeeper runs. It will not start before the second converge
# This node is not defined before converge is finished, and zookeeper config does
# not contain this node, and therefore refuses to start.
