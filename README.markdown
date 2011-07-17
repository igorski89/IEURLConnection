`NSURLConnection` subclass with both support for block callbacks and delegation

    #!c
    NSURL *imageURL = [NSURL URLWithString:@"http://icanhascheezburger.files.wordpress.com/2011/06/funny-pictures-nyan-cat-wannabe1.jpg"];
    IEURLConnection *connection = [IEURLConnection connectionWithRequest:[NSURLRequest requestWithURL:imageURL]];
    connection.didFailWithErrorHandler = ^(NSError *error) {
        [UIAlertView showAlertWithTitle:@"Download error" message:[error localizedDescription]];
    
        self.downloadButton.enabled = YES;
        self.progressView.progress = 0.0f;
    };
    connection.didFinishLoadingHandler = ^(NSURLResponse *response, NSData *responseData){
        self.imageView.image = [UIImage imageWithData:responseData];
        self.downloadButton.enabled = YES;
    };
    connection.downloadProgressHandler = ^(float progress){
        self.progressView.progress = progress;
    };

    [connection start];


see more in my blog post [http://evsukov.posterous.com/ieurlconnection-nsurlconnection-subclass-with](http://evsukov.posterous.com/ieurlconnection-nsurlconnection-subclass-with)
