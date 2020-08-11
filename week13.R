### Library Required for Linked Access ###

library(httr)



### OAuth settings for linkedin ###

### https://developer.linkedin.com/documents/linkedins-oauth-details ###

access <- oauth_endpoints("linkedin")



### Register an application at https://www.linkedin.com/secure/developer ###

### Make sure to register http://localhost:1410/ as an "OAuth 2.0 Redirect URL".###

### (the trailing slash is important!) ###



### Replace key and secret below. ###



myapp1 <- oauth_app("linkedin", key = "outmkw3859gy", secret = "n7vBr3lokGOCDKCd")



### Getting OAuth credentials and specifying a scope for our app has permission ###



token <- oauth2.0_token(access, myapp1, scope = "r_liteprofile")



### Using API ###



req <- GET("https://api.linkedin.com/v2/me", config(token = token))

stop_for_status(req)

content(req)

### Source Links ###

### https://www.r-bloggers.com/analyze-instagram-with-r/ ###

### https://github.com/r-lib/httr/blob/master/demo/oauth2-linkedin.r ###