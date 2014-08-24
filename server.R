df=NULL

shinyServer(function(input, output) {
  output$intro <- renderText({
    buy.year = strptime(date(), "%a %b %d %H:%M:%S %Y")
    sell.year = input$sell.year
    final.period = sell.year - 1900 - buy.year$year
    
    paste0("Investing $", 
           format(input$investment, nsmall=2, decimal.mark=".", big.mark=","),
           " today at ",
           format(input$avg.return * 100, nsmall=2, decimal.mark="."),
           "% for ",
           final.period,
           " years would grow to the following amounts for the different asset types."
    )
  })
  output$returnsTable <- renderTable({
      value <- function(period) {
        current.value = investment * ((1 + (avg.return - annual.expense))) ^ period
        current.value = format(current.value, nsmall=2, decimal.mark=".", big.mark=",")
        current.value
      }
      
      investment = input$investment
      avg.return = input$avg.return
      period = 1
      buy.year = strptime(date(), "%a %b %d %H:%M:%S %Y")
      sell.year = input$sell.year
      final.period = sell.year - 1900 - buy.year$year
      sell.year = buy.year
      sell.year$year = buy.year$year + final.period
      initial.expense = 10
      final.expense = 10
      periods = period:final.period
      
      df = as.data.frame(periods)
      colnames(df) = c("Periods")
      df.expenses = as.data.frame(c("Zero Expenses",
                                    "Small US ETF","Large US ETF",
                                    "Passive MF","Passive Taxable MF",
                                    "Active MF","Active Taxable MF"))
      colnames(df.expenses) = c("Asset Type")
      df.expenses$Expense = 0
      
      #Zero Expenses
      annual.expense = 0
      df.expenses[1,2] = paste0(annual.expense * 100, ".00%")
      df$Zero_Expenses = value(periods)
      #ETF Small US
      annual.expense = 0.0044 + 0.0191
      df.expenses[2,2] = paste0(annual.expense * 100, "%")
      df$Small_US_ETF = value(periods)
      #ETF Large US
      annual.expense = 0.0044 + 0.0021
      df.expenses[3,2] = paste0(annual.expense * 100, "%")
      df$Large_US_ETF = value(periods)
      #MF Passive
      annual.expense = 0.0074 + 0.0144 + 0.0083
      df.expenses[4,2] = paste0(annual.expense * 100, "%")
      df$Passive_MF = value(periods)
      #MF Passive Taxable
      annual.expense = 0.0074 + 0.0144 + 0.0083 + 0.01
      df.expenses[5,2] = paste0(annual.expense * 100, "%")
      df$Passive_MF_Tax = value(periods)
      #MF Active
      annual.expense = 0.0090 + 0.0144 + 0.0083
      df.expenses[6,2] = paste0(annual.expense * 100, "%")
      df$Active_MF = value(periods)
      #MF Active Taxable
      annual.expense = 0.0090 + 0.0144 + 0.0083 + 0.01
      df.expenses[7,2] = paste0(annual.expense * 100, "%")
      df$Active_MF_Tax = value(periods)
      df.expenses
      
      colnames(df) = c("Periods", "Zero Expenses",
                       "Small US ETF","Large US ETF",
                       "Passive MF","Passive Taxable MF",
                       "Active MF","Active Taxable MF")
      df[nrow(df),2:ncol(df)]
  })
  output$costs <- renderText({
    "The average cumulative annual costs for each asset type are as follows:"
  })
  output$costsTable <- renderTable({
    df.expenses = as.data.frame("Total Expenses (%)")
    
    #Zero Expenses
    annual.expense = 0
    df.expenses$Zero = paste0(annual.expense * 100, ".00%")
    #ETF Small US
    annual.expense = 0.0044 + 0.0191
    df.expenses$SmallETF = paste0(annual.expense * 100, "%")
    #ETF Large US
    annual.expense = 0.0044 + 0.0021
    df.expenses$LargeETF = paste0(annual.expense * 100, "%")
    #MF Passive
    annual.expense = 0.0074 + 0.0144 + 0.0083
    df.expenses$PassiveMF = paste0(annual.expense * 100, "%")
    #MF Passive Taxable
    annual.expense = 0.0074 + 0.0144 + 0.0083 + 0.01
    df.expenses$PassiveMFTax = paste0(annual.expense * 100, "%")
    #MF Active
    annual.expense = 0.0090 + 0.0144 + 0.0083
    df.expenses$ActiveMF = paste0(annual.expense * 100, "%")
    #MF Active Taxable
    annual.expense = 0.0090 + 0.0144 + 0.0083 + 0.01
    df.expenses$ActiveMFTax = paste0(annual.expense * 100, "%")
    
    colnames(df.expenses) = c("", "Zero Expenses",
                              "Small US ETF","Large US ETF",
                              "Passive MF","Passive Taxable MF",
                              "Active MF","Active Taxable MF")
    df.expenses
  })
  output$returns <- renderText({
    "A picture as they say is worth a thousand words!"
  })
  output$returnsChart <- renderPlot({
    library(ggplot2)
    library(reshape2)
    value <- function(period) {
      current.value = investment * ((1 + (avg.return - annual.expense))) ^ period
      #current.value = format(current.value, nsmall=2, decimal.mark=".", big.mark=",")
      current.value
    }
    
    investment = input$investment
    avg.return = input$avg.return
    period = 1
    buy.year = strptime(date(), "%a %b %d %H:%M:%S %Y")
    sell.year = input$sell.year
    final.period = sell.year - 1900 - buy.year$year
    sell.year = buy.year
    sell.year$year = buy.year$year + final.period
    initial.expense = 10
    final.expense = 10
    periods = period:final.period
    
    df = as.data.frame(periods)
    colnames(df) = c("Periods")
    
    #Zero Expenses
    annual.expense = 0
    df$Zero_Expenses = value(periods)
    #ETF Small US
    annual.expense = 0.0044 + 0.0191
    df$Small_US_ETF = value(periods)
    #ETF Large US
    annual.expense = 0.0044 + 0.0021
    df$Large_US_ETF = value(periods)
    #MF Passive
    annual.expense = 0.0074 + 0.0144 + 0.0074 + 0.0083
    df$Passive_MF = value(periods)
    #MF Passive Taxable
    annual.expense = 0.0074 + 0.0144 + 0.0074 + 0.0083 + 0.01
    df$Passive_MF_Tax = value(periods)
    #MF Active
    annual.expense = 0.0090 + 0.0144 + 0.0074 + 0.0083
    df$Active_MF = value(periods)
    #MF Active Taxable
    annual.expense = 0.0090 + 0.0144 + 0.0074 + 0.0083 + 0.01
    df$Active_MF_Tax = value(periods)
    colnames(df) = c("Periods", "Zero Expenses",
                     "Small US ETF","Large US ETF",
                     "Passive MF","Passive Taxable MF",
                     "Active MF","Active Taxable MF")
    
    df <- melt(df,id=c("Periods"))
    colnames(df) = c("Year", "Asset_Type",
                          "Value")
    qplot(Year,Value,data=df,colour=Asset_Type,
          geom="line",main="Mutual Fund/ETF Perfromance")
  })
  output$outro <- renderText({
    paste("Hence, when you make investment decisions pay careful",
      " attention to all fees associated with the type of asset.",
      " In general ETFs are a much cheaper way of diversifying.",
      " However, if you but buy and sell often the transaction",
      " costs will eat into your returns.")
  })
})