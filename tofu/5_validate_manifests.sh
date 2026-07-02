tofu fmt -recursive

tofu validate

rm plan.tofu
tofu plan -no-color -out=plan.tofu