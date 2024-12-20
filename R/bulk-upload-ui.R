# # License

# The NPM calculator and underlying nutrientprofiler R package provide functions to help assess product information against the UK Nutrient Profiling Model (2004/5) and scope for HFSS legislation around product placement. It is designed to provide low level functions that implement UK Nutrient Profiling Model scoring that can be applied across product datasets.

# Copyright (C) 2024 University of Leeds

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# A copy of the GNU Affero General Public License is supplied
# along with this program in the `LICENSE` file in the repository.
# You can also find the full text at https://www.gnu.org/licenses.

# You can contact us by raising an issue on our GitHub repository (https://github.com/Leeds-CDRC/NPM-Calculator/issues/new - login required) or by emailing
# us at info@cdrc.ac.uk.
# bulk upload shiny component
library(shiny)
library(DT)

# define a tabPanel for introducing the NPM Table calculator
introTab <- tabPanel(
  title = tags$b("NPM Table Calculator"),
  value = "bulkDataDesc",
  h3("NPM Table Calculator"),
  # p("At present the Table Calculator is experimental and not guaranteed
  # to work against all data. Please use the available template spreadsheet files
  # to populate your data against and run with the Table Calculator. This ensures
  # the data contains correct column names and categories for steps used by the 
  # Table Calculator.",
  # class= "alert alert-warning"),
  # p("The Table Calculator uses the nutrientprofiler R package to calculate
  # NPM scores. Find out more about this package here:",a("nutrient profiler documentation",
  # href="https://leeds-cdrc.github.io/nutrientprofiler/", style = "color:white;font-weight: bold;", target="_blank")," . This tool currently uses",a("nutrientprofiler version 2.0.0.",
  # href="https://github.com/Leeds-CDRC/nutrientprofiler/releases/tag/v1.0.0", style = "color:white;font-weight: bold;", target="_blank"),"Please note this alongside your analysis. ",
  # class= "alert alert-success"),
  p("The Table Calculator mode enables you to upload information for multiple products and run the entire table through the Nutrient Profile Model.",
  br(),
  br(),
  "How to use the Table Calculator mode:"),
  tags$ol(
    tags$li("Download the template Excel or CSV file at bottom of this page."),
    tags$li("Prepare your data, ensuring you are using the correct column names and categories (the template Excel file contains drop down options for categorical variables)."),
    tags$li("Select the ‘upload data’ tab."),
    tags$li("Upload your Excel or CSV file – once uploaded you can preview to check the data looks correct."),
    tags$li("Click ‘Calculate NPM scores’."),
    tags$li("The calculator will provide a summary and small preview of the results. Any errors will be flagged at this stage."),
    tags$li("Download your full results (CSV file)."),
  ),
  br(),
  br(),
  h4("Help using the tool"),
  p("Link will go here to guide video."),
  br(),
  p("Please see the 'Table Calculator Guide' section of the 'User guide'
  for more information on the parameters required."),

  # p("To help with larger datasets of product information
  # you want testing against the Nutrient Profile Model we 
  # have introduced a new, experimental Table Calculator mode.
  # This mode offers the ability to upload a dataset of product
  # information and run the entire table through the Nutrient Profile
  # Model. It visualises these results and makes it possible to 
  # download a copy of your data with the additional columns
  # corresponding to the Nutrient Profile Model assessment."),
  # p("Once you have prepared your data click Next and move to
  # the Upload Data tab. There you can upload your data file 
  # which should be either CSV or Excel format. Once uploaded
  # your data will be previewed within that tab where you can 
  # visually check the data looks correct. When ready click Calculate
  # NPM scores to run the Table Calculator against your data. If an error
  # occurs during this step a popup will appear that includes some error
  # information. If it is unclear how to fix your error please raise an
  # issue on ",a(href="https://github.com/Leeds-CDRC/NPM-Calculator/issues/new",
  # "GitHub (sign in required) ")," sharing your error information or email the CDRC via ",
  # a(href="mailto:info@cdrc.ac.uk", "info@cdrc.ac.uk"),
  # " including all error information."),
  # p("If this step proceeds without error you will move to the Results
  # tab, where you will be able to view a summary of your results and a 
  # small preview table of your data showing the result of the NPM 
  # calculation. You will also be able to download your dataset as a CSV file
  # with additional columns generated during the assessment step."),
  
  # p("The template Excel file below contains drop down options for categorical variables to assist you in correctly filling in your dataset.",
  #                                           class= "alert alert-success"),
  # a centered row that contains anchors for downloading
  # template data files
  fluidRow(style = "text-align:center;",
    column(12,
          a(href="example-NPM-data.xlsx", 
          "Download template Excel file", 
          download=NA, 
          target="_blank",
          class="btn btn-primary"),
        a(href="example-NPM-data.csv", 
          "Download template CSV file", 
          download=NA, 
          target="_blank",
          class="btn btn-primary")
        ),
      ),
      # row containing button to move to next tab
      fluidRow(style = "margin: 1.5%; text-align:center;",
        column(12,
              actionButton('moveBulkTab', "Next", icon = icon("nutritionix"),
              style = "color: white; background-color: teal;", width = '40%'),
        )
      ),
    p("Should you experience any difficulties using the NPM Calculator, please contact", a(href="mailto:info@cdrc.ac.uk", "info@cdrc.ac.uk", style = "color:white;font-weight: bold;"), "including a screenshot of any relevant error messages.",
                                            class= "alert alert-success"),
      )



# define a tabPanel for the uploading data tab
tableTab <- tabPanel(
    title = tags$b("Upload data"),
    value = "bulkDataUpload",
      # Sidebar layout with input and output definitions ----
  sidebarLayout(
    # Sidebar panel for inputs ----
      sidebarPanel(
        width = 3,
        h3("NPM Table Calculator"),
        p("Use the below options to upload a local file.
        If the file is a .csv please specify the additional options below otherwise if using
        and Excel file just proceed to the Calculate button."),

            # Input: Select a file ----
        fileInput("file1", "Choose CSV/Excel File",
                  multiple = FALSE,
                  accept = c("text/csv",
                          "text/comma-separated-values,text/plain",
                          ".csv",
                          ".xlsx")),
        
        actionButton('runBulk', "Calculate NPM scores", icon = icon("nutritionix"),
              style = "color: white; background-color: teal", width = '100%')
      ),

      # Main panel for displaying outputs ----
      mainPanel(
        h4("Your uploaded data"),
        # Output: Data file ----
        DTOutput("bulkTable", height = "500px"),
        p("Common sources of error include: incorrect or missing column names; missing required parameters; and empty or blank rows. If you receive an error message, please check your input data to ensure no required information is missing.", 
                      class= "alert alert-warning"),
      )
    ),


)


# define a tabPanel for the results of running the nutrient profiler pipeline
resultTab <- tabPanel(tags$b("Results"), value = "bulkResult",
                      h3("Results"),
                      br(),
                      p("See below for the NPM calculator results on your dataset. 
                      You can also download this updated dataframe via the Download button."),
                      fluidRow(column(8, 
                               downloadButton("downloadData", "Download Data with NPM Assessment"),
                               plotOutput("bulkResultPlot", height = 200) )
                      ),
                      p("If one of your data entries returns ERROR instead of an NPM assessment and score (PASS or FAIL), please check that all required parameters have been filled in. Ensure 'fvn_measurement_percent' is set to a value at/between 0 and 100.", 
                      class= "alert alert-warning"),
                      DTOutput("bulkResultTable", 
                      height = "500px"),
                      p("The Table Calculator uses the nutrientprofiler R package to calculate
                        NPM scores. Find out more about this package here:",a("nutrient profiler documentation",
                        href="https://leeds-cdrc.github.io/nutrientprofiler/", style = "color:white;font-weight: bold;", target="_blank")," . This tool currently uses",a("nutrientprofiler version 2.0.0.",
                        href="https://github.com/Leeds-CDRC/nutrientprofiler/releases/tag/v1.0.0", style = "color:white;font-weight: bold;", target="_blank"),"Please note this alongside your analysis. ",
                        class= "alert alert-success"),
                      )

# the main tab constructor
# this variable contructs the full tab panel from
# all other tabs defined above
bulkTab <- tabPanel("Table Calculator",
                    value = "bulkCalc",
                    tabsetPanel(type = "tabs", 
                                shinyjs::useShinyjs(), 
                                id ="calc2",
                                introTab,
                                tableTab,
                                resultTab
                    )
)