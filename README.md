
# Requirements

* Vagrant, recommended version >1.8
* Virtualbox
* r10k

**By now, the Windows boxes are not publicly available due to copyright restrictions. We try to work around this.**

Example for OSX:

    $ sudo gem install r10k

# Setup

    $ r10k puppetfile install

# Run

    $ vagrant up --provider virtualbox

After you started all nodes, you have to login to  the nodes and issue `puppet agent -t`. Since `carina is the puppetmaster, it has to be up and running during your puppet runs.

## Run a minimal setup

Since these boxes were created to simulate an entire network, at least the gateway node `draco` is needed to run other boxes. If you want to use Puppet to provision the setup as it was intended, you need `carina`, too, before starting any other node.

The node `fornax` is the Icinga 2 master - you will want to start experimenting with this node but you should start it as the last of the setup.
