#!/bin/sh

: ${GALAXY_VIRTUAL_ENV:=.venv}
if [ ! -e "$GALAXY_VIRTUAL_ENV" ]; then
    python3 -m venv "$GALAXY_VIRTUAL_ENV";
    . "$GALAXY_VIRTUAL_ENV/bin/activate"
    pip install gx-tool-db
fi
. "$GALAXY_VIRTUAL_ENV/bin/activate"

# sheed_output='sheet:1N84CziEyW0Z109slrL33cuFt3Wpuu037zogkBMhk-C0'
gx-tool-db export-tabular \
    --name --description --model-class --tool-shed --repository-owner --repository-name \
    --training-topics --training-tutorials \
    --coverage main --coverage eu \
    --test test --test anvil_production --test anvil_edge \
    --label iwc_required --label deprecated --label critical \
    --output "data.tsv"
