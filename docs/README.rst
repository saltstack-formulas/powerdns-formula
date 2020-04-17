.. _readme:

powerdns
========

|img_travis| |img_sr|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/powerdns-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/powerdns-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release

Installs a basic PowerDNS authorative server, and enables different backend configurations.

.. contents:: **Table of Contents**

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please pay attention to the ``pillar.example`` file and/or `Special notes`_ section.

Contributing to this repo
-------------------------

**Commit message formatting is significant!!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

Special notes
-------------

None

Available states
----------------

.. contents::
   :local:


``powerdns``
^^^^^^^^^^^^

Installs PowerDNS authorative server.


``powerdns.repo``
^^^^^^^^^^^^^^^^^

Installs PowerDNS authorative server from official repostiory.

``powerdns.backend-ldap``
--------------------------

Installs PowerDNS LDAP backend package.

``powerdns.backend-mysql``
^^^^^^^^^^^^^^^^^^^^^^^^^^

Installs PowerDNS MySQL backend package.

``powerdns.backend-sqlite3``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Installs PowerDNS sqlite3 backend package.
Initializes sqlite3 db specified in config pillar.


``powerdns.config``
^^^^^^^^^^^^^^^^^^^

Configures PowerDNS authorative server.

``powerdns.api``
^^^^^^^^^^^^^^^^

Installs the required pdnsapi python module. Requires pip to work.

To use this module, you need to have the following set either in pillar
or your minion config:

.. code:: SaltStack


    pdns.url: "http://127.0.0.1:8081"
    pdns.server_id: "localhost"
    pdns.api_key: "deadbeef"

Testing
-------

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``TEMPLATE`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.

