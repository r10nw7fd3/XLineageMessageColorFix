package r10nw7fd3.xlineagemessagecolorfix;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.callbacks.XC_LoadPackage.LoadPackageParam;
import de.robv.android.xposed.XposedBridge;
import static de.robv.android.xposed.XposedHelpers.findAndHookMethod;

public class Main implements IXposedHookLoadPackage {
	private static final String BASE_PACKAGE = "com.android.messaging";
	private static final String HOOK_TARGET = BASE_PACKAGE + ".ui.ConversationDrawables";
	private static final String HOOK_TARGET_METHOD = "getBubbleDrawable";

	@Override
	public void handleLoadPackage(final LoadPackageParam lpparam) throws Throwable {
		if(!lpparam.packageName.equals(BASE_PACKAGE))
			return;

		XposedBridge.log("Trying to hook into " + HOOK_TARGET + "#" + HOOK_TARGET_METHOD);

		findAndHookMethod(
			HOOK_TARGET,
			lpparam.classLoader,
			HOOK_TARGET_METHOD,
			boolean.class,
			boolean.class,
			boolean.class,
			boolean.class,
			String.class,
			new Hook()
		);
	}
}
