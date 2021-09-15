

: ${GALAXY_VIRTUAL_ENV:=.venv}
if [ ! -e "$GALAXY_VIRTUAL_ENV" ]; then
    python3 -m venv "$GALAXY_VIRTUAL_ENV";
    . "$GALAXY_VIRTUAL_ENV/bin/activate"
    pip install gx-tool-db
fi
. "$GALAXY_VIRTUAL_ENV/bin/activate"

git submodule update --init

gx-tool-db import-server --server main
gx-tool-db import-server --server eu

gx-tool-db import-tests ./tests_tool_test_ouptut.json test
# best_indexwise will keep successful runs of a particular index even if more recent failed,
# our goal with this repo is to determine if the tool ever worked - thinking that transient errors
# are more likely caused by infrastructure problems than regressions in Galaxy.
gx-tool-db import-tests anvil-misc/reports/anvil-production/tool-tests/ anvil_production --merge-strategy best_indexwise
gx-tool-db import-tests anvil-misc/reports/anvil-edge/tool-tests/ anvil_edge --merge-strategy best_indexwise

gx-tool-db label-workflow-tools ./iwc/ --label iwc_required
gx-tool-db label-workflow-tools ./iwc/ --label critical

gx-tool-db import-trainings ./training-material

gx-tool-db import-label deprecated_tools.txt deprecated
