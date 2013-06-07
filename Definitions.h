#define kFacebookAppId @"283267091688130"
#define kFacebookSecret @"9e33f416c1e040392c89b03af688ebd9"

#define kFacebookLoginDisallowed @"com.facebook.sdk:SystemLoginDisallowedWithoutError"
#define kFacebookLoginErrorKey @"com.facebook.sdk:ErrorLoginFailedReason"

#define kOAuthConsumerKey @"d08a9w6ehrNAuceIcsDR9w"
#define kOAuthConsumerSecret @"LBE3JE4ZPeGdKt2xLQVg0sQ2VbiieRvuR5PbPC4w"

typedef enum
{
    listViewController
}typeViewController;


/*  MACROS */

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height > 480.0f) ? YES : NO)

#define INT_TO_STRING(int) [NSString stringWithFormat:@"%i", int]

#define ALL_TRIM( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

#define DEG_2_RAD(degrees) (degrees * 0.01745327) // degrees * pi over 180

#define UICOLOR_FROM_RGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]
