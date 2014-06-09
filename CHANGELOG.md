# 0.9.2 / 2014-04-30
* [BIGFIX] Do not add suffix to queue names - added by Propono.

# 0.9.1 / 2014-04-30
* [FEATURE] Raise exceptions when thread dies 

# 0.9.0 / 2014-04-12
* [FEATURE] Change activesupport dependency to allow for Rails 4

# 0.8.0 / 2014-04-04
* [FEATURE] Move from /system to /spi
* [BUGFIX] Fix broken daemon test in spawned daemons

# 0.7.3 / 2014-04-03
* [FEATURE] Support message replay through a utility class.

# 0.7.2 / 2014-02-26
* [BUGFIX] Add logging every 60secs to worker pool.

# 0.7.1 / 2014-02-26
* [BUGFIX] Fix issue with SDK secret being incorrectly set to nil.

# 0.7.0 / 2014-02-24
* [FEATURE] Add configurator

# 0.6.5 / 2014-02-23
* [FEATURE] Add extra logging to worker pool
* [FEATURE] Remove upstart script
* [FEATURE] Use IAM roles in spawned config
* [FEATURE] Test template config, not sample config.

# 0.6.4 / 2014-02-23
* [BUGFIX] Use camelize, not classify

# 0.6.3 / 2014-02-23
* [FEATURE] Git init and commit new daemon.

# 0.6.2 / 2014-02-23
* [FEATURE] Remove meducation_sdk by default.

# 0.6.1 / 2014-02-23
* [FEATURE] Remove larva version dependency in spawner.

# 0.6.0 / 2014-02-23
* [FEATURE] Add larva binfile.

# 0.5.0 / 2014-02-23
* [FEATURE] Rely on Propono config for queue suffix.
* [FEATURE] Add daemon support.
* [FEATURE] Add mocking support.
* [FEATURE] Add configuration to inherit from.

# 0.4.1 / 2014-02-22
* [FEATURE] Remove need for process method.

# 0.4.0 / 2014-02-22
* [FEATURE] Add meta-programming-based processors.

# 0.3.0 / 2014-02-22
* [FEATURE] Add worker pool.

# 0.2.0 / 2014-02-22
* [FEATURE] Add processor.

# 0.1.0 / 2014-02-22
* [FEATURE] Initial release with listeners.
