
usegalaxy.* Tool Database Project
----------------------------------

This project contains a YAML database that is meant to maintain metadata and annotations
about the tools installed on usegalaxy.* servers. This database can be turned into Galaxy
artifacts for installing tools and managing tools using the `gx-tool-db application <https://github.com/jmchilton/gx-tool-db>`__
(installable via pip).

-------------------------
Automatic Metadata
-------------------------

This script ``bootstrap_db.sh`` was used to seed the initial metadata for installed tools from
a variety of sources. This script uses ``gx-tool-db`` to import data about installed versions from
main and EU, test data from container tests ran by Nate while migrating main to use Singularity,
Anvil test data, tools used in IWC and Training Material workflows, and an initial set of deprecations
just hand curated by John.

---------------------------
Adding Metadata
---------------------------

We can attach arbitrary additional metadata in a few ways. People can PR changes to the the tool metadata
YAML directly. By restricting these manual changes to the "external_labels" key, we can ensure that both
automatic metadata import from gx-tool-db will not interfere with manual annotations and vice versa.

The YAML format is straight forward and adding labels should be relatively easy. Here are examples of a
tool we marked as critical because it is used by an IWC workflow.

::

  toolshed.g2.bx.psu.edu/repos/bgruening/replace_column_by_key_value_file/replace_column_with_key_value_file:
    external_labels:
    - iwc_required
    - critical
    servers:
      eu:
        sections:
          text_manipulation:
            name: Text Manipulation
        versions:
        - '0.1'
        - '0.2'
      main:
        sections:
          text_manipulation:
            name: Text Manipulation
        versions:
        - '0.2'



And here is entry for a deprecated tool. It was marked as deprecated because it appears in the deprecated
tools list.

::

  toolshed.g2.bx.psu.edu/repos/devteam/cummerbund_to_tabular/cummerbund_to_cuffdiff:
    external_labels:
    - deprecated
    servers:
      eu:
        sections:
          rna_analysis:
            name: RNA Analysis
        versions:
        - 1.0.0
        - 1.0.1
      main:
        sections:
          rna_analysis__deprecated_:
            name: RNA Analysis (deprecated)
        versions:
        - 1.0.1
    tool_shed_repository:
      name: cummerbund_to_tabular
      owner: devteam
      tool_shed: toolshed.g2.bx.psu.edu
    versions:
      1.0.0:
        description: tabular files from a cummeRbund database
        model_class: Tool
        name: Extract CuffDiff
        servers:
          eu:
            labels: []
      1.0.1:
        description: tabular files from a cummeRbund database
        model_class: Tool
        name: Extract CuffDiff
        servers:
          eu:
            labels: []
          main:
            labels:
            - deprecated
        test_results:
          test:
            0:
              job_create_time: '2021-09-04T03:24:47.244714'
              status: failure
            1:
              job_create_time: '2021-09-04T03:25:01.531347'
              status: failure
            2:
              job_create_time: '2021-09-04T03:25:14.481085'
              status: failure
            3:
              job_create_time: '2021-09-04T03:27:16.741777'
              status: failure
            4:
              job_create_time: '2021-09-04T03:27:17.004564'
              status: failure
            5:
              job_create_time: '2021-09-04T03:25:43.263001'
              status: failure
            6:
              job_create_time: '2021-09-04T03:26:23.397688'
              status: failure
            7:
              job_create_time: '2021-09-04T03:27:36.495277'
              status: failure
            8:
              job_create_time: '2021-09-04T03:27:31.368399'
              status: failure
            9:
              job_create_time: '2021-09-04T03:27:38.404272'
              status: failure
            10:
              job_create_time: '2021-09-04T03:27:31.797232'
              status: failure
            11:
              job_create_time: '2021-09-04T03:27:34.188103'
              status: failure
            12:
              job_create_time: '2021-09-04T03:27:43.848849'
              status: failure
            13:
              job_create_time: '2021-09-04T03:27:58.422892'
              status: failure
            14:
              job_create_time: '2021-09-04T03:27:52.500455'
              status: failure
            15:
              job_create_time: '2021-09-04T03:28:08.296545'
              status: failure
            16:
              job_create_time: '2021-09-04T03:28:10.571750'
              status: failure
            17:
              job_create_time: '2021-09-04T03:28:23.516071'
              status: failure
            18:
              job_create_time: '2021-09-04T03:28:23.179924'
              status: failure
            19:
              job_create_time: '2021-09-04T03:28:19.808624'
              status: failure
            20:
              job_create_time: '2021-09-04T03:28:24.398666'
              status: failure
            21:
              job_create_time: '2021-09-04T03:28:28.295134'
              status: failure
            22:
              job_create_time: '2021-09-04T03:28:32.212509'
              status: failure
        trainings:
        - topic: transcriptomics
          tutorial: rna-seq-viz-with-cummerbund
```

Manually editing the YAML was not the end goal here though. We can dump tabular versions 
of all this data to spreadsheets or Google Sheets, manually edit the results, and then
re-import the labels back.

John can produce the sheets and re-import the data from people who manually edit the sheets
or the details of doing the syncing are documented on the README for gx-tool-db.

------------------
Tool Panel Views
------------------

I'm worried that the perfect is becoming the enemy of the improved when people are wanting to
work on the tool panel.

- Bjoern wants to eliminate the dinstinction between Ephemeris' installed tools setup.
- Anton wants to redo all the section labels.

I think these both have pitfalls that we should skip over for now in an attempt to get something
working. I think we should set some really easy targets, produce two useful
tool panels, and improve the process after that.

The two tool panels we should produce are:

- The best practices tool panel. This contains just the tools labeled as critical tools,
  tools used by IWC workflows, and tools used by trainings.
- A flavor (e.g. covid19.usegalaxy.org).

Once that is working we can improve the process and work on more tool panels - additional
flavors and an exapnded version of the best practice tool panel that includes more tools
but still excludes everything deprecated and maybe filtering on a new tag like "uninteresting".

------------------
Action Items
------------------

- Just start expanding the deprecated tools list. It should be marked as deprecated
  because the tool should no longer be used in the abstract. If some installation or
  runtime problem is simply preventing it from working on main there should be a different
  label. We can build as many simple lists of tools this way as we want.
- Review and expand the list of critical tools.

  - Using spreadsheets syncing or manual annotation in the YAML file.

- Establish a covid19.usegalaxy.org (or rna.usegalaxy.org) - really whichever flavor is fine.

  - Use gx-tool-db to add a label to each tool that appears on covid19.usegalaxy.eu.
  - Dump a tool panel that contains only those tools with that label out and install on usegalaxy.org.
  - Verify the tool panel is good on main, work with Nate on establishing covid19.usegalaxy.org
    that points at the same Galaxy runtime - one small config tweak can change the default tool
    panel view for requests targetting that domain.
