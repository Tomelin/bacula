# bacula

[Bacula Server]: http://blog.bacula.org/

[Puppet module]: https://docs.puppetlabs.com/puppet/latest/reference/modules_fundamentals.html

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What is the bacula module, and what does it do?](#module-description)
3. [Setup - The basics of getting started with bacula](#setup)
    * [What bacula affects](#what-bacula-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with bacula](#beginning-with-bacula)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Class director affects](#class-director-affects)
	    * [Dependency class director affects](#dependency-class-director-affects)
    * [Class storage affects](#class-storage-affects)
    * [Class client affects](#class-client-affects)
    * [Class proftpd affects](#class-proftpd-affects)
    * [Class selinux affects](#class-selinux-affects)
    * [Class firewall affects](#class-firewall-affects)
    * [Class monitored affects](#class-monitored-affects)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)


## Overview

A one-maybe-two sentence summary of what the module does/what problem it solves.
This is your 30 second elevator pitch for your module. Consider including
OS/Puppet version it works with.

## Module Description

[Bacula Server] is a widely used backup the servers windows, linux, MAC.... 
This [Puppet module] simplifies the task of creating configurations to manage Bacula servers in your infrastructure. It can configure the jobs, pools, bacula storage e bacula clients in linux, also configured monitorament, selinux and firewall with firewalld.
This module test in bacula version 7x.

## Setup

### What bacula affects

* A list of files, packages, services, or operations that the module will alter,
  impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form.

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled,
etc.), mention it here.

### Beginning with bacula

The very basic steps needed for a user to get the module up and running.

If your most recent release breaks compatibility or requires particular steps
for upgrading, you may wish to include an additional section here: Upgrading
(For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

## Usage

Put the classes, types, and resources for customizing, configuring, and doing
the fancy stuff with your module here.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

This is where you list OS compatibility, version compatibility, etc.

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You may also add any additional sections you feel are
necessary or important to include here. Please use the `## ` header.
