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
