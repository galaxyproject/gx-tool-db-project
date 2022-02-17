

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

gx-tool-db import-server-as-label --url https://rna.usegalaxy.eu rna
gx-tool-db import-server-as-label --url https://covid19.usegalaxy.eu covid19
gx-tool-db import-server-as-label --url https://assembly.usegalaxy.eu assembly
gx-tool-db import-server-as-label --url https://hicexplorer.usegalaxy.eu hicexplorer
gx-tool-db import-server-as-label --url https://virology.usegalaxy.eu virology
gx-tool-db import-server-as-label --url https://nanopore.usegalaxy.eu nanopore
gx-tool-db import-server-as-label --url https://ecology.usegalaxy.eu ecology
gx-tool-db import-server-as-label --url https://climate.usegalaxy.eu climate
gx-tool-db import-server-as-label --url https://metagenomics.usegalaxy.eu metagenomics
gx-tool-db import-server-as-label --url https://microgalaxy.usegalaxy.eu microgalaxy
gx-tool-db import-server-as-label --url https://singlecell.usegalaxy.eu singlecell
gx-tool-db import-server-as-label --url https://humancellatlas.usegalaxy.eu humancellatlas
gx-tool-db import-server-as-label --url https://clipseq.usegalaxy.eu clipseq
gx-tool-db import-server-as-label --url https://plants.usegalaxy.eu plants
gx-tool-db import-server-as-label --url https://graphclust.usegalaxy.eu graphclust
gx-tool-db import-server-as-label --url https://cheminformatics.usegalaxy.eu cheminformatics
gx-tool-db import-server-as-label --url https://imaging.usegalaxy.eu imaging
gx-tool-db import-server-as-label --url https://metabolomics.usegalaxy.eu metabolomics
gx-tool-db import-server-as-label --url https://ml.usegalaxy.eu ml
gx-tool-db import-server-as-label --url https://annotation.usegalaxy.eu annotation
