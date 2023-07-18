package r10nw7fd3.xlineagemessagecolorfix;

import de.robv.android.xposed.XC_MethodHook;

// Because my flawed build system does not support nested classes
public class Hook extends XC_MethodHook {
	@Override
	protected void beforeHookedMethod(XC_MethodHook.MethodHookParam param) throws Throwable {
		param.args[4] = null;
	}
}
