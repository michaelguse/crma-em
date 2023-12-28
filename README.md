This repository contains sample assets for dashboards, widgets, lenses for the Salesforce CRMA app, and more specifically for Event Monitoring related tasks.

# Inventory of Assets

## HeatmapWithDayToogle - CRMA Dashboard

This asset provides the user with a dashboard that contains a toggle (pillbox widget) to allow the timeline charts time dimension to be changed with a click (toggle).

<img width="1216" alt="Screenshot of the full dashboard" src="https://github.com/michaelguse/crma-em/assets/654874/e91bdf0b-d75c-4c85-a9e4-06fd3fbf677f">

Additionally it displays the count for the entity type on the left-hand side and it provides a filter by ENTITY_TYPE at the top of the page.

### Pre-Requisites

To deploy this dashboard into your CRMA environment it is expected that you have Event Monitoring licensed and that the OOTB  Event Monitoring app is installed. At a minimum this asset requires the Lightning Interaction event log file to be available from the Event Monitoring app. This file is typically part of a standard install.

### Steps to deploy this dashboard into your CRMA environment:
- Create a blank new dashboard in Analytics Studio
- Click CTRL-E (or COMMAND-E on a Mac) to show the JSON for the dashboard.
- Go to Github and copy the JSON code for this asset
- Go back to Analytics Studio and replace the JSON from the new dashboard with the JSON code you just copied from Github.
- Change the **label** of the JSON file and give it the name you want to use in your org.
- Replace all dataset references with the appropriate **Name, Label** and **ID**
  - The name and label items typically use the same name
  - And the name should match the default naming that the EM app provides, but they could vary, in which case you want to do a global find & replace for it
- Replace the dataset ID with the ID for the Lightning Interaction event log file in your CRMA environment.
  - Explore the Lightning Interaction data set in your environment and copy the ID from the URL for it
  - Go back to the dashboard JSON file and find & replace all old dataset ID references with the just copied ID value
- Once you are comfortable that all the dataset references have been changed go ahead and click the **'DONE'** button on the top right.
- Assuming there is no error message, click the **'Save'** button on the top right of the dashboard to save all of your changes you just  made to the JSON file
- Now test your changed dashboard by clicking the **'Preview'** button and validate that everything looks like it is working
- And that's it!

Good luck with using this dashboard to get a quick start on a dynamic filter example and have fun expanding it to whatever your requirements dictate.

:)
