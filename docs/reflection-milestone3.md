We have deployed the same framework done in milestone 2 for milestone 3 as well. That is, we have compared the weather conditions with the energy consumption patterns of a European house.

# Features Implemented
We have two tabs in the dashboard with a sidebar and 2 plots in each tab. 

### Sidebar

* The sidebar is linked to the plots and allows the plot to be updated dynamically.
* Dropdown 'compare' values in sidebar update based on the data being used in that tap.
* The multi select is removed in the R version of this dashboard as this feature is built in in R and we can select the required legends instead.
* 'Timescale' radio select features options to aggregate the data to see patterns in time-groups.
*  Date picker implemented.

### Tab 1
* Tab 1 has visualizations of average of Temperature and Humidity against time.
* Figures dynamically interact with dropdown category selection.
* The legends can be used to select the required sub categories.
* Displayed figures update dynamically with timescale selected.


### Tab 2
* The date picker component is used to dynamically update plot 1 and plot2 on the energy usage.
* Time series visualization with sidebar dropdown integration for variable selection.

# Features Not Yet Implemented

* App styling and formatting not yet tidied and formalized. Appearance is still a rough draft, not a final product.
* Tab 2 may end up adding another visualization in our final dashboard to compare dropdown items.
* The App is slow and should be made faster and cleaner.

## Reflections on implementing the same app in 2 different languages

* The built-in interactivity of the base visualizations in ggplot is useful for  implementation and user interactivity .
* The feedback received was positive and we will be going ahead with the future enhancements as planned.
* The modular coding was implemented in python version of the app and it was not implemented in the R version of this app.
* The modular version of the code was easier to debug as everything was divided into different components.
* The R version has multiple lines of code in a single file which could become troublesome to debug in case of any errors.
