library(ggplot2)
library(plotly)
library(dplyr)
library(gapminder)

# p <- gapminder %>%
#   filter(year==1977) %>%
#   ggplot( aes(gdpPercap, lifeExp, size = pop, color=continent,
#               country = country)) +
#   geom_point() +
#   theme_bw()
# 
# ggplotly(p)
# 

library(shiny)

ui <- fluidPage(
  "hello world",
  sliderInput("yearThresh", 
              "Use data more recent than:", 
              1952, 2007, 1952),
  plotOutput("lifeGDPPlot"), 
  plotlyOutput("lifeGDPPlotly"), 
)

server <- function(input, output, session) {
  output$lifeGDPPlot <- renderPlot({
    # data <- gapminder::gapminder %>%
    #   filter(year >= input$yearThresh) %>%
    #   group_by(country) %>%
    #   summarize(lifeExp = mean(lifeExp),
    #             gdpPercap = mean(gdpPercap))
    
    ggplot(data(), aes(x = gdpPercap, y = lifeExp)) + geom_point()
  })
  
  output$lifeGDPPlotly <- renderPlotly({
    
    p <- ggplot(data(), aes(x = gdpPercap, y = lifeExp)) + geom_point()
    ggplotly(p)
  })
  
  data <- reactive({
    data <- gapminder::gapminder %>%
      filter(year >= input$yearThresh) %>%
      group_by(country) %>%
      summarize(lifeExp = mean(lifeExp),
                gdpPercap = mean(gdpPercap))
    data
  })
}

shinyApp(ui, server)










