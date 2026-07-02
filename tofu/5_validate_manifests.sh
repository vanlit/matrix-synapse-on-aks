tofu fmt -recursive

tofu validate

# note: never create plan with .tf OR .tofu extension - that will break the execution
# as such file will be treated as another manifest, too, and, beign binary, will produce loads of parsing errors
rm plan.tfplan
tofu plan -no-color -out=plan.tfplan