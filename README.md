# CentOS 7 LAPP Stack for QA

## Copyright and Licensing

### Copyright Notice

The copyright for the software, documentation, and associated files are
held by the author.

    Copyright © 2015, 2016, 2017 Todd A. Jacobs
    All rights reserved.

The AUTHORS file is also included in the source tree.

### Software License

![GPLv3 Logo][1]

The software is licensed under the [GPLv3][2]. The LICENSE file is
included in the source tree.

### README License

![Creative Commons BY-NC-SA Logo][3]

This README is licensed under the [Creative Commons
Attribution-NonCommercial-ShareAlike 4.0 International License][4].

## Purpose
Minimalist LAPP stack environment for integration testing with Cucumber
and Capybara.

## Use Case
The general use case is ATDD or regression testing on a releatively
recent LAPP stack, with Cucumber and Capybara driving a headless
PhantomJS browser. The scripted setup is meant to run from the top level
of your PHP source code, and assumes that your Cucumber features will
reside in */vagrant/features* inside the VM.

This project (currently) deliberatly sidesteps the more complex issues
around configuring Apache and PHP, although they can generally be solved
by copying conf and ini files from the source tree or the host. See
"Caveats" for other assumptions.

## Dependencies
1. [Vagrant](https://www.vagrantup.com/)
1. [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)
1. [VirtualBox](https://www.virtualbox.org/)
1. [Ansible](https://www.ansible.com/)

## Installation and Setup
This project is meant to be run as a submodule within your source tree.
If you invert this relationship, just disable or reconfigure Vagrant's
synced folders.

    git submodule add https://github.com/CodeGnome/centos7-lapp-qa.git \
        vagrant
    git commit -m 'Add Vagrant support as a submodule.' \
        .gitmodules centos7-lapp-qa

    cd vagrant
    ./vagrant_provision.sh

*NB: Older versions of Git may not initialize submodules automatically.
Consider using `git submodule update --init --recursive` or related
commands if the submodule directory is empty.*

## Usage
You can log into the VM from the command line with Vagrant, the
VirtualBox GUI, or connect to the web server with your browser.

### CLI
    vagrant ssh

    # Source code from host is mounted inside the VM.
    ls /usr/local/src

### Browser
    http://localhost:8080

### Adding Gems
The expectation is that your project's source code is being mounted at
*/usr/local/src*, and that you will want to run the gems bundled into
your application's source code. However, some testers don't have the
luxury of having their testing harness included in the mainline. If
that's your case, you can pull down any Gemfile you like and then
`bundle install` them into the VM's environment.

If you don't have your own, consider using the author's
[Cucumber-centric Gemfile][5] as a base. For example, assuming your Git
repository is already mounted properly:

    cd /usr/local/src
    curl -sLo Gemfile https://goo.gl/iNsBjr
    bundle install

    # Tell Git to ignore your custom files.
    for file in Gemfile{,.lock} .bundle do
        echo "$file" >> .git/info/exclude
    done

Other solutions, such as installing the bundle in your home directory
and relying on rbenv shims to invoke the right gems without calling
`bundle exec` (which won't find a bundle in some other directory), are
certainly possible. This will install shims for your currently-select
Ruby, which you can use the installed gems almost anywhere that it isn't
being overriden simply by omitting `bundle`exec`.

## Common Errors

> Vagrant was unable to mount VirtualBox shared folders.

This is caused by a mismatch (or absence of) the VirtualBox Guest
Additions. Run `vagrant plugin install vagrant-vbguest` and then rerun
the provisioning script.

> ERROR! the role 'zzet.rbenv' was not found

This happens when Ansible is installed as root, or when the current user
on the host doesn't have write access to the Ansible directories.
Running `sudo ansible-galaxy install zzet.rbenv` and then rerunning the
provisioning script will fix it.

## Caveats
This project is a base. It still needs customization to:

1. configure Apache and PHP for your code base
1. point the document root at the source code presumably mounted at
   */vagrant*
1. set up any additional testing tools not installed through Bundler

**WARNING**: Ansible currently has a horrible, horrible bug that causes
playbook breakage when run from a path with spaces in it. If your source
tree is in */somewhere with/a lot/of spaces* then you will be sorry.
When you're done regretting that you didn't remember this warning when
your playbook reports a fatal error, please go file a bug against
Ansible and (quite possibly) Vagrant's Ansible provisioner.

## To-Do
The Ansible playbook is a bit unlovely, somewhat by design. The goal has
always been to get testing quickly rather than spend a great deal of
time yak-shaving the initial baseline. However, modularizing the
playbook would be a useful pull request, provided that it doesn't
overcomplicate the file tree. There's a balance in all things, and
striking the right balance between monolithic files and pugnaciously
indirect coding styles is hard to get right.

So yes, better readability and some additional flexibility are on the
to-do list. Eventually. Probably when you send me a pull request. 🙈🙉🙊

[1]: http://www.gnu.org/graphics/gplv3-88x31.png
[2]: http://www.gnu.org/copyleft/gpl.html
[3]: http://i.creativecommons.org/l/by-nc-sa/3.0/us/88x31.png
[4]: https://creativecommons.org/licenses/by-nc-sa/4.0/
[5]: https://goo.gl/iNsBjr
