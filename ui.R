shinyUI(
  fluidPage(
    # Application title
    titlePanel("ETFs vs. Mutual Funds"),
    
    sidebarLayout(
      sidebarPanel(
        # General Section
        h4("Investment Info"),
        numericInput("investment", "Initial Investment:",
                     value=10000, min=1000, max=100000000,
                     step=1000),
        sliderInput("avg.return","Average Annual Rate of Return (%):",
                    min = .01, max = .1,value = .07,step=0.0025, 
                    format="#.##%", locale="us"),
        numericInput("sell.year", "Year Asset Will Be Sold:",
                     value=2044, min=2015, max=2084,
                     step=1),
        submitButton("Submit"),
        
        h4("Types of Costs"),
        helpText("There are three categories of costs associated with Exchange Traded Funds (ETFs) and Mutual Funds (MFs)."),
        #a(href="http://guides.wsj.com/personal-finance/investing/how-to-choose-an-exchange-traded-fund-etf/"),
        
        h5("Overhead (Expense Ratios)"),
        helpText("Average ETF: 0.74%"),
        helpText("Average Passive MF: 0.74%"),
        helpText("Average Active MF: 0.90%"),
        
        h5("Transaction (Commissions, Market Impact, Bid/Ask)"),
        helpText("Average Small (NAV < $50 million) US ETF: 1.91%"),
        helpText("Average Large (NAV < $10 billion) US ETF: 0.21%"),
        helpText("Average Passive MF: 1.44%"),
        #helpText("Average Active MF: 1.44%"),
        
        h5("Other (Cash Drag, Tax)"),
        helpText("Average ETF: 0.74%"),
        helpText("Average MF: 0.83% + 1.00%")
      ),
      
      # Main content
      mainPanel(
        textOutput("intro"),
        tableOutput("returnsTable"),
        textOutput("costs"),
        tableOutput("costsTable"),
        textOutput("returns"),
        plotOutput("returnsChart"),
        textOutput("outro")
      )
    )
  )
)