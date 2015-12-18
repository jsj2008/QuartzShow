

#import "RenderParametersView.h"
#import "CompositionParametersView.h"

#define kHMargin				10
#define kVMargin					10
#define kHExtra					20
#define kVExtra					20

@implementation RenderParametersView

- (BOOL) isFlipped
{
	return YES;
}

- (id) initWithFrame:(NSRect)frameRect
{
	//Allocate the QCViewer list
	if(self = [super initWithFrame:frameRect])
	_QCRenderers = [NSMutableArray new];
	return self;
}

- (void) dealloc
{
	//Destroy QCRenderer list
	[_QCRenderers release];
	[super dealloc];
}

- (void) _arrangeSubviews
{
	NSArray*						subviews = [self subviews];
	NSView*						view;
	unsigned						i;
	NSSize							size;
	
	//Set subviews origins and compute total size 
	_bestSize = NSZeroSize;
	for(i = 0; i < [subviews count]; ++i) {
		view = [subviews objectAtIndex:i];
		size = [view frame].size;
		if(size.width > _bestSize.width)
		_bestSize.width = size.width;
		[view setFrameOrigin:NSMakePoint(kHMargin, kVMargin + _bestSize.height)];
		_bestSize.height += size.height;
	}
	
	//Match subviews widths
	for(i = 0; i < [subviews count]; ++i) {
		view = [subviews objectAtIndex:i];
		[view setFrameSize:NSMakeSize(_bestSize.width, [view frame].size.height)];
	}
	
	//Add horizontal and vertical margins to total size
	if(_bestSize.width > 0)
	_bestSize.width += 2 * kHMargin;
	if(_bestSize.height > 0)
	_bestSize.height += 2 * kVMargin;
}

- (NSSize) bestSize
{
	return _bestSize;
}

- (void) addQCRender:(QCRenderer *)QCRendererer  title:(NSString*)title
{
	CompositionParametersView*		view;
	NSBox*								box;
	NSSize									size;
	
	//Make sure the QCViewer is valid and not already in the list
	if(!QCRendererer  || ![title length] || [_QCRenderers  containsObject:QCRendererer])
	return;
	
	//Create CompositionParametersView for QCViewer, wrap it in an NSBox and add it as a subview
	view = [[CompositionParametersView alloc] initWithQCRenderer:QCRendererer ];
	[view setAutoresizingMask:NSViewWidthSizable];
	size = [view minimumSize];
	box = [[NSBox alloc] initWithFrame:NSMakeRect(0, 0, size.width + kHExtra, size.height + kVExtra)];
	[box setTitle:title];
	//[box setAutoresizingMask:NSViewWidthSizable];
	[box setContentView:view];
	[self addSubview:box];
	[box release];
	[view release];
	
	//Update QCRenderer list
	[_QCRenderers  addObject:QCRendererer  ];
	//Rearrage all subviews
	[self _arrangeSubviews];
}

- (void) removeQCRenderer:(QCRenderer  *)QCRendererer
{
	unsigned		index = [_QCRenderers  indexOfObject:QCRendererer];
	
	//Make sure QCRenderer is in the list
	if(index == NSNotFound)
	return;
	
	//Remove related subview
	[(NSView*)[[self subviews] objectAtIndex:index] removeFromSuperview];
	
	//Update QCRenderer list
	[_QCRenderers  removeObjectAtIndex:index];
	
	//Rearrage all subviews
	[self _arrangeSubviews];
}

- (void) removeAllQCRenderers
{
	//Remove renderers from list and remove their related subviews
	while([_QCRenderers count]) {
		[(NSView*)[[self subviews] objectAtIndex:0] removeFromSuperview];
		[_QCRenderers  removeObjectAtIndex:0];
	}
	 
	//Rearrange all subviews
	[self _arrangeSubviews];
}

- (NSArray*) QCRenderers
{
	return _QCRenderers ; //FIXME: Return a copy instead?
}

- (NSDictionary*) parameters:(BOOL)plistCompatible
{
	NSMutableDictionary*			dictionary = [NSMutableDictionary new];
	NSArray*							subviews = [self subviews];
	NSDictionary*					subDictionary;
	unsigned							i;
	NSBox*							box;
	
	//Iterate through QCRenderers
	for(i = 0; i < [subviews count]; ++i) {
		//Retrieve QCRenderer input parameters from its CompositionParametersView
		box = [subviews objectAtIndex:i];
		subDictionary = [(CompositionParametersView*)[box contentView] parameters:plistCompatible];
		
		//Add parameters to dictionary
		if([subDictionary count])
		[dictionary setObject:subDictionary forKey:[box title]];
	}
	return [dictionary autorelease];
}

- (void) setParameters:(NSDictionary*)parameters
{
	NSArray*						subviews = [self subviews];
	NSDictionary*				dictionary;
	unsigned						i;
	NSBox*						box;
	
	//Iterate through QCRenderers
	for(i = 0; i < [subviews count]; ++i) {
		//Retrieve parameters from dictionary
		box = [subviews objectAtIndex:i];
		dictionary = [parameters objectForKey:[box title]];
		
		//Set QCRenderer input parameters through its CompositionParametersView
		if([dictionary count])
		[(RenderParametersView*)[box contentView] setParameters:dictionary];
	}
}

@end
