Never edit .yaml, only edit yaml.tpl, unless there is no yaml.pl, then just edit the yaml.
The pre-commit hook under /flow/ must be enabled so
.tpl files will be converted on-commit to .yaml files, embedding the values from /cfg.sh