/* CGSPrivate.h -- Header file for undocumented CoreGraphics stuff. */

#include <Carbon/Carbon.h>

/* These functions all return a status code. Typical CoreGraphics replies are:
kCGErrorSuccess = 0,
kCGErrorFirst = 1000,
kCGErrorFailure = kCGErrorFirst,
kCGErrorIllegalArgument = 1001,
kCGErrorInvalidConnection = 1002,
*/

// Internal CoreGraphics typedefs
typedef int		CGSConnection;
typedef int		CGSWindow;
typedef int		CGSValue;

// Transitions we can apply
typedef enum {
	CGSNone = 0,			// No transition effect.
	CGSFade,				// Cross-fade.
	CGSZoom,				// Zoom/fade towards us.
	CGSReveal,				// Reveal new desktop under old.
	CGSSlide,				// Slide old out and new in.
	CGSWarpFade,			// Warp old and fade out revealing new.
	CGSSwap,				// Swap desktops over graphically.
	CGSCube,				// The well-known cube effect.
	CGSWarpSwitch,			// Warp old, switch and un-warp.
	CGSFlip					// Flip over
} CGSTransitionType;

// All our transition styles - passed under "option" when invoking
// Mostly just directions
// Transparent Mask "(1<<7)" goes with option if applied.
typedef enum {
	CGSDown,			// Old desktop moves down.
	CGSLeft,			// Old desktop moves left.
	CGSRight,			// Old desktop moves right.
	CGSInRight,			// CGSSwap: Old desktop moves into screen,
						// new comes from right.
	CGSBottomLeft = 5,	// CGSSwap: Old desktop moves to bottom-left,
						// new comes from top-right.
	CGSBottomRight,		// Old desktop to br, New from tl.
	CGSDownTopRight,	// CGSSwap: Old desktop moves down, new from tr.
	CGSUp,				// Old desktop moves up.
	CGSTopLeft,			// Old desktop moves tl.
	CGSTopRight,		// CGSSwap: old to tr. new from bl.
	CGSUpBottomRight,	// CGSSwap: old desktop up, new from br.
	CGSInBottom,		// CGSSwap: old in, new from bottom.
	CGSLeftBottomRight,	// CGSSwap: old one moves left, new from br.
	CGSRightBottomLeft,	// CGSSwap: old one moves right, new from bl.
	CGSInBottomRight,	// CGSSwap: onl one in, new from br.
	CGSInOut			// CGSSwap: old in, new out.
} CGSTransitionOption;

/* Get the default connection for the current process. */
extern CGSConnection _CGSDefaultConnection(void);

// Behaviour of window during expose / regarding workspaces
typedef enum {
	CGSTagNone					= 0,		// No tags
	CGSTagExposeFade		= 0x0002,		// Fade out when Expose activates.
	CGSTagNoShadow			= 0x0008,		// No window shadow.
	CGSTagTransparent   = 0x0200,   		// Transparent to mouse clicks.
	CGSTagSticky				= 0x0800,	// Appears on all workspaces.
} CGSWindowTag;

/* Get the default connection for the current process. */
extern CGSConnection _CGSDefaultConnection(void);

typedef struct {
	uint32_t unknown1;
	CGSTransitionType type;
	CGSTransitionOption option;
	CGSWindow wid;			/* Can be 0 for full-screen */
	float *backColour;	/* Null for black otherwise pointer to 3 float array with RGB value */
} CGSTransitionSpec;

/* Transition handling. */
extern OSStatus CGSNewTransition(const CGSConnection cid, const CGSTransitionSpec* spec, int *pTransitionHandle);
extern OSStatus CGSInvokeTransition(const CGSConnection cid, int transitionHandle, float duration);
extern OSStatus CGSReleaseTransition(const CGSConnection cid, int transitionHandle);

// thirtyTwo must = 32 for some reason. tags is pointer to 
//array ot ints (size 2?). First entry holds window tags.
// 0x0800 is sticky bit.
extern OSStatus CGSGetWindowTags(const CGSConnection cid, const CGSWindow wid, CGSWindowTag *tags, int thirtyTwo);
extern OSStatus CGSSetWindowTags(const CGSConnection cid, const CGSWindow wid, CGSWindowTag *tags, int thirtyTwo);
extern OSStatus CGSClearWindowTags(const CGSConnection cid, const CGSWindow wid, CGSWindowTag *tags, int thirtyTwo);
extern OSStatus CGSGetWindowEventMask(const CGSConnection cid, const CGSWindow wid, uint32_t *mask);
extern OSStatus CGSSetWindowEventMask(const CGSConnection cid, const CGSWindow wid, uint32_t mask);

// Gets the screen rect for a window.
extern OSStatus CGSGetScreenRectForWindow(const CGSConnection cid, CGSWindow wid, CGRect *outRect);

// Window appearance/position
extern OSStatus CGSSetWindowAlpha(const CGSConnection cid, const CGSWindow wid, float alpha);
extern OSStatus CGSSetWindowListAlpha(const CGSConnection cid, CGSWindow *wids, int count, float alpha);
extern OSStatus CGSGetWindowAlpha(const CGSConnection cid, const CGSWindow wid, float* alpha);
extern OSStatus CGSMoveWindow(const CGSConnection cid, const CGSWindow wid, CGPoint *point);
extern OSStatus CGSSetWindowTransform(const CGSConnection cid, const CGSWindow wid, CGAffineTransform transform); 
extern OSStatus CGSGetWindowTransform(const CGSConnection cid, const CGSWindow wid, CGAffineTransform * outTransform); 
extern OSStatus CGSSetWindowTransforms(const CGSConnection cid, CGSWindow *wids, CGAffineTransform *transform, int n); 

extern OSStatus CGSUncoverWindow(const CGSConnection cid, const CGSWindow wid);
extern OSStatus CGSFlushWindow(const CGSConnection cid, const CGSWindow wid, int unknown /* 0 works */ );

extern OSStatus CGSGetWindowOwner(const CGSConnection cid, const CGSWindow wid, CGSConnection *ownerCid);
extern OSStatus CGSConnectionGetPID(const CGSConnection cid, pid_t *pid, const CGSConnection ownerCid);

// Values

extern int CGSIntegerValue(CGSValue intVal);
extern void *CGSReleaseGenericObj(void*);