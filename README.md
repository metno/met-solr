# met-solr-cookbook

Installs the solr database. I allows for one server per node only.
Installs zookeeper. It allows for one server per node only.
You can pair a solr database and a zookeeper server on each node.

## Supported Platforms

Debian based platforms. Tested with ubuntu 14.04

## Attributes

See the attributes directory

## Usage

### met-solr::default

Include `met-solr` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[met-solr::default]"
  ]
}
```

Here is an an example of how to use the met_solr_core to create a new core
named "placenames" in your recipe:

```
met_solr_core "placenames" do
          source "solr/cores/placenames"
          action :create
end
```
The solr core config directory "placenames" is placed in files/default/solr/cores/placenames

## License and Authors

Author:: Espen Myrland (met-api@met.no)
