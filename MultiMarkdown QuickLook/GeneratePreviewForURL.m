#import <CoreFoundation/CoreFoundation.h>
#import <CoreServices/CoreServices.h>
#import <QuickLook/QuickLook.h>
#import <Cocoa/Cocoa.h>

/* -----------------------------------------------------------------------------
 Generate a preview for file
 
 This function's job is to create preview for designated file
 ----------------------------------------------------------------------------- */

NSData* processDayOne(NSURL* url);

BOOL logDebug = YES;


OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
    if (logDebug)
        NSLog(@"generate preview for content type: %@",contentTypeUTI);
    
    CFDataRef previewData;
    
    previewData = (CFDataRef) processDayOne((NSURL*) url);
    
    if (previewData) {
        if (logDebug)
            NSLog(@"preview generated");
        
        CFDictionaryRef properties = (CFDictionaryRef) [NSDictionary dictionaryWithObject:@"UTF-8" forKey:(NSString *)kQLPreviewPropertyTextEncodingNameKey];
        QLPreviewRequestSetDataRepresentation(preview, previewData, kUTTypeHTML, properties);
    }
    
    return noErr;
}


NSData* processDayOne(NSURL* url)
{
    if (logDebug)
        NSLog(@"create preview for MMD file %@",[url path]);
		
    NSString *path2MMD = [[NSBundle bundleWithIdentifier:@"net.fletcherpenney.quicklook"] pathForResource:@"multimarkdown" ofType:nil];
    
		NSTask* task = [[NSTask alloc] init];
		[task setLaunchPath: [path2MMD stringByExpandingTildeInPath]];
		
    [task setArguments: [NSArray arrayWithObjects: nil]];
		
		NSPipe *writePipe = [NSPipe pipe];
		NSFileHandle *writeHandle = [writePipe fileHandleForWriting];
		[task setStandardInput: writePipe];
		
		NSPipe *readPipe = [NSPipe pipe];
		[task setStandardOutput:readPipe];
		
		[task launch];
    
    NSStringEncoding encoding = 0;
		
    // Ensure we used proper encoding - try different options until we get a hit
		//  if (plainText == nil)
    //    plainText = [NSString stringWithContentsOfFile:[url path] usedEncoding:<#(NSStringEncoding *)#> error:<#(NSError **)#> encoding:NSASCIIStringEncoding];
    
		
    NSString *theData = [NSString stringWithContentsOfFile:[url path] usedEncoding:&encoding error:nil];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<key>Entry Text</key>.*?<string>(.*?)</string>" options:NSRegularExpressionDotMatchesLineSeparators error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:theData options:0 range:NSMakeRange(0, [theData length])];
    NSRange matchRange = [match rangeAtIndex:1];
    theData = [theData substringWithRange:matchRange];

		NSString *cssDir = @"~/.dayoneqlstyle.css";
		if ([[NSFileManager defaultManager] fileExistsAtPath:[cssDir stringByExpandingTildeInPath]]) {
				NSString *cssStyle = [NSString stringWithFormat:@"\n<style>body{-webkit-font-smoothing:antialiased;padding:20px;max-width:900px;margin:0 auto;}%@</style>",[NSString stringWithContentsOfFile:[cssDir stringByExpandingTildeInPath] encoding:NSUTF8StringEncoding error:nil]];
				theData = [theData stringByAppendingString:cssStyle];
				if (logDebug) {
						NSLog(@"Using located style ~/.dayoneqlstyle.css: %@",cssStyle);
				}
		} else {
                theData = [theData stringByAppendingString:@"\n<style>*{ font-family:Avenir,Helvetica Neue,Helvetica,Arial,freesans,clean,sans-serif}html,body,h1,h2,h3,h4,h5,h6,p,blockquote,pre,code,em,img,small,strong,sub,sup,b,i,dl,dt,dd,ol,ul,li,table,tbody,tfoot,thead,tr,th,td{ border:0;  font-size:16px; margin:0; padding:0; outline:0}body{  background-color:rgba(255,255,255,0.0); padding-top:12px; padding-right:60px; padding-bottom:9px; padding-left:60px; color:#333}img{ display:block; padding:10px 0; max-width:100%}.video_embed{ display:block; padding:10px 0; height:<videoheight>px; width:<screenwidth>px}em{ color:#373737}strong{ color:#252525}a{ color:#47B1C7; text-decoration:none}a:hover{ color:#EA4C89}hr{ border:0; border-top:1px solid #eaeaea; display:block; height:1px; margin:1em 0; padding:0}h1{ font-size:1.2em; font-weight:700; line-height:1.3; margin:10px 0 7px}h1.title{ font-size:1.2em; font-weight:700; color:#26748F; line-height:1.3; margin:11px 0 16px}h2{ color:#333; font-size:1em; font-weight:700; line-height:1.2; margin:22px 0 7px}h3,h4,h5,h6{ line-height:1.1; margin:24px 0 5px}h3{ color:#EA4C89; font-size:.85em; font-weight:700; text-transform:uppercase}h4{ color:#26748F; font-size:1.1em; font-weight:700; padding-bottom:3px; border-bottom:1px solid #ddd}h5{ font-size:1em; font-weight:700; color:#26748F}h6{ color:#415F6C; font-size:.85em; font-weight:700; font-variant:italic; border-bottom:1px solid #ddd; padding-bottom:3px; text-transform:uppercase}dl,ol,ul,p,blockquote,pre{ margin-top:12px; margin-bottom:18px}ol,ul{ margin:.8em 0; padding-left:23px}ol li{ margin-left:.5em; margin-bottom:.3em}ul li{ margin-left:.5em; margin-bottom:.3em}ol ol,ol ul,ul ol,ul ul{ margin:.3em 0}.footnotes ol li{ margin-bottom:10px; margin-left:16px; font-weight:800; font-size:.9em}.footnotes ol li p{ font-weight:400; font-size:1em}blockquote{ border-left:solid .4em #ddd; padding-left:10px; quotes:none}pre,code,tt{ font:1em 'Bitstream Vera Sans Mono',Courier New,monospace}pre{ background-color:#f8f8f8; border:#E8E8E8 1px solid; color:#444; display:block; margin:12px 0; overflow:auto; padding:6px 10px; white-space:pre-wrap; word-wrap:break-word; cursor:text; max-width:100%; overflow:auto; border-radius:3px; -webkit-border-radius:3px}code{ color:#2c92b0; border:1px solid #E8E8E8; font-size:.95em; border-radius:3px; -moz-border-radius:3px; -webkit-border-radius:3px}pre code{ font-size:.95em; padding:0 !important; background-color:#F6F6F6; border:none !important; overflow:visible}table{ margin-right:auto; margin-top:10px; margin-bottom:5px; border-bottom:1px solid #ddd; border-right:1px solid #ddd; border-spacing:0}table th{ padding:3px 10px; background-color:#eee; border-top:1px solid #ddd; border-left:1px solid #ddd}table tr{}table td{ padding:3px 10px; border-top:1px solid #ddd; border-left:1px solid #ddd}sup,sub,a.footnote{ font-size:1.4ex; height:0; line-height:1; vertical-align:super; position:relative; font-weight:800}sub{ vertical-align:sub; top:-1px}small{ font-size:85%}mark{ background:#ff0; color:#000; font-style:italic; font-weight:600}.highlight {background:#fff}.highlight .c{color:#998;font-style:italic}.highlight .err{color:#a61717;background-color:#e3d2d2}.highlight .k{font-weight:bold}.highlight .o{font-weight:bold}.highlight .cm{color:#998;font-style:italic}.highlight .cp{color:#999;font-weight:bold}.highlight .c1{color:#998;font-style:italic}.highlight .cs{color:#999;font-weight:bold;font-style:italic}.highlight .gd{color:#000;background-color:#fdd}.highlight .gd .x{color:#000;background-color:#faa}.highlight .ge{font-style:italic}.highlight .gr{color:#a00}.highlight .gh{color:#999}.highlight .gi{color:#000;background-color:#dfd}.highlight .gi .x{color:#000;background-color:#afa}.highlight .go{color:#888}.highlight .gp{color:#555}.highlight .gs{font-weight:bold}.highlight .gu{color:#800080;font-weight:bold}.highlight .gt{color:#a00}.highlight .kc{font-weight:bold}.highlight .kd{font-weight:bold}.highlight .kn{font-weight:bold}.highlight .kp{font-weight:bold}.highlight .kr{font-weight:bold}.highlight .kt{color:#458;font-weight:bold}.highlight .m{color:#099}.highlight .s{color:#d14}.highlight .na{color:#008080}.highlight .nb{color:#0086B3}.highlight .nc{color:#458;font-weight:bold}.highlight .no{color:#008080}.highlight .ni{color:#800080}.highlight .ne{color:#900;font-weight:bold}.highlight .nf{color:#900;font-weight:bold}.highlight .nn{color:#555}.highlight .nt{color:#000080}.highlight .nv{color:#008080}.highlight .ow{font-weight:bold}.highlight .w{color:#bbb}.highlight .mf{color:#099}.highlight .mh{color:#099}.highlight .mi{color:#099}.highlight .mo{color:#099}.highlight .sb{color:#d14}.highlight .sc{color:#d14}.highlight .sd{color:#d14}.highlight .s2{color:#d14}.highlight .se{color:#d14}.highlight .sh{color:#d14}.highlight .si{color:#d14}.highlight .sx{color:#d14}.highlight .sr{color:#009926}.highlight .s1{color:#d14}.highlight .ss{color:#990073}.highlight .bp{color:#999}.highlight .vc{color:#008080}.highlight .vg{color:#008080}.highlight .vi{color:#008080}.highlight .il{color:#099}.type-csharp .highlight .k{color:#00F}.type-csharp .highlight .kt{color:#00F}.type-csharp .highlight .nf{color:#000;font-weight:normal}.type-csharp .highlight .nc{color:#2B91AF}.type-csharp .highlight .nn{color:#000}.type-csharp .highlight .s{color:#A31515}.type-csharp .highlight .sc{color:#A31515}</style>"];
				
				if (logDebug) {
						NSLog(@"Using internal style");
				}
		}
    
    if (logDebug)
        NSLog(@"Used %lu encoding",(unsigned long) encoding);
		
		[writeHandle writeData:[theData dataUsingEncoding:NSUTF8StringEncoding]];
    
		[writeHandle closeFile];
		
		
		NSData *mmdData = [[readPipe fileHandleForReading] readDataToEndOfFile];

    [task release];
		return mmdData;
}

void CancelPreviewGeneration(void* thisInterface, QLPreviewRequestRef preview)
{
    // implement only if supported
}
