$("#ajaxmessage").empty();
$("#ajaxmessage").html("<%= escape_javascript raw(flash_display) %>");
$(".scraperdetails").remove();
$("#scraper_attr").prepend("<%= j(render 'scraper',  scraper:@scraper) %>");
