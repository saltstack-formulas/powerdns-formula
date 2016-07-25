powerdns
========

Installs a basic PowerDNS authorative server, and enables different backend configurations.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.


Usage
=====

All the configuration for powerdns is done via pillar (pillar.example).


Available states
================

.. contents::
    :local:


``powerdns``
------------

Installs PowerDNS authorative server.


``powerdns.repo``
-----------------

Installs PowerDNS authorative server from official repostiory.


``powerdns.backend-mysql``
--------------------------

Installs PowerDNS MySQL backend package.


``powerdns.config``
-------------------

Configures PowerDNS authorative server.
