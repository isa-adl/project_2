server  <- function(input, output) {
    
    
    ### DATA TABLE
    output$table = DT::renderDataTable({
        datatable(owid_covid, rownames = F) 
    })
    
    
    ### GRAPHS 
    plot_trends <- function(){
        top_7countries_OW %>%  
            filter(location == input$location) %>% 
            # filter(month == input$month) %>% 
            ggplot(aes(x = date, y = total_cases)) +
            geom_line()
    }
    output$plot_top_7countries_OW <- plotly::renderPlotly({
        validate(
            need(input$location != "", "Select a country and month to get the app working")
        )
        plot_trends()
    })
    
    output$table_top_7countries_OW <- DT::renderDT({
        top_7countries_OW %>% 
            filter(location == input$location)%>% 
            # filter(month == input$month) %>% 
            select(location, date, total_cases)
    })
    
    output$plt_top_7countries = renderPlot({ 
        ggplot(top_7countries_3, aes(date, total_cases))  +
            geom_line(aes(group = location, color = location))+
            ylab("Total Cases")+
            ggtitle("Total Cases in Countries with the Most Cases")
    })
    
    output$plt_top_7countries_pm = renderPlot({ 
        ggplot(top_7countries_3, aes(date, total_cases_per_million))  +
            geom_line(aes(group = location, color = location))+
            ylab("Total Cases per Million") +
            ggtitle("Total Cases per Million in Countries with the Most Cases")
    })
    
    
    ### World Map
    
    output$map = renderPlotly({
#         
#         owid_mselected = owid_mdy %>% filter(., month == input$month)
#         
#         plot_geo(owid_mselected) %>% 
#             add_trace(z = owid_mselected[, owid_mselected$total_cases], color = owid_mselected[, owid_mselected$total_cases], 
#                       colors = 'Reds',
#                       text = owid_mselected$location,
#                       locations = owid_mselected$iso_code, 
#                       marker = list(line = list(color = toRGB("grey"), width = 0.5))) %>% 
#             colorbar(title = '', ticksuffix = '') %>% 
#             layout(geo = list(
#                 showframe = FALSE,
#                 showcoastlines = FALSE,
#                 projection = list(type = 'Mercator')
#             ))
#         
#     })
#     
# }
plot_geo(
    owid_mdy %>% 
        ungroup() %>% 
        filter(month==input$month) %>%
        mutate(
            location=countrycode(location, origin = 'country.name', destination = 'genc3c')
        ) %>%
        group_by(location) %>%
        summarise(value=max(total_cases_per_million))
) %>%
    add_trace(
        z = ~value, locations = ~location, colors="Greens",
        marker = list(line = list(color = toRGB("grey"), width = 0.5))
    ) %>% 
    colorbar(
        title = '', ticksuffix = '') %>%
    layout(
        geo = list(
            showframe = FALSE,
            showcoastlines = FALSE,
            projection = list(type = 'Mercator')),
        title = "Total Cases per Million Worldwide"
    
        )

})
    
}



# shinyServer(function(input, output){
#     # show map using googleVis
#     output$map <- renderGvis({
#         gvisGeoChart(bycountry, "country",input$selected,
#                      options=list( width="auto", height="auto"))
#     })
# 
#     # })
#     # Function to plot trends in a country
#     plot_trends <- function(){
#         bycountry_date %>%
#             group_by(date) %>%
#             filter(country == input$country, type == "confirmed")%>%
#             ggplot(aes(x = date, y = total_cases)) +
#             geom_line()
#     }
#     output$plot_eachcountry <- plotly::renderPlotly({
#         plot_trends()
#     })
# 
#     # # show data using DataTable
#     output$table_eachcountry <- DT::renderDT({
#         bycountry_date
#          })
# #     #
#     # show statistics using infoBox
#     output$maxBox <- renderInfoBox({
#         max_value <- max(owid_covid[,input$selected])
#         max_country <-
#             owid_covid$location[owid_covid[,input$selected] == max_value]
#         infoBox(max_country, max_value, icon = icon("hand-o-up"))
#     })
#     output$minBox <- renderInfoBox({
#         min_value <- min(owid_covid[,input$selected])
#         min_country <-
#             owid_covid$location[owid_covid[,input$selected] == min_value]
#         infoBox(min_country, min_value, icon = icon("hand-o-down"))
#     })
#     
# })  
#     # output$avgBox <- renderInfoBox(
#     #     infoBox(paste("AVG.", input$selected),
#     #             mean(bycountry[,input$selected]),
#     #             icon = icon("calculator"), fill = TRUE))
# })

