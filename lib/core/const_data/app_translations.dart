import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        // English
        'en': {
          //settings screen
          'settings': 'Settings',
          'theme': 'Theme',
          'light': 'Light',
          'dark': 'Dark',
          'language': 'Language',
          'notifications': 'Notifications',
          //homepage
          'Loading_name': 'Loading...',
          'Welcome': 'Welcome ',
          'Due Today': 'Due Today',
          'Today’s Completed': 'Today’s Completed',
          'Streak': 'Streak',
          'days': 'days',
          ''
                  "Small steps every day lead to big results.":
              "Small steps every day lead to big results.",
          'See All': 'See All',
          //achievements card
          'Progress: ': 'Progress: ',
          'Completed': 'Completed',
          'Complete your tasks and get awards:':
              'Complete your tasks and get awards:',
          "No_Achievements": "🎉 No Achievements Added Yet!",
          //floating action button
          'Add_Task_ach': 'Add Task',
          'Add_Note_ach': 'Add Note',
          //schedule screen
          "Schedule": "Tasks Schedule",
          "No tasks scheduled for": "No tasks scheduled for",
          //incomplete tasks screen
          'My Tasks': 'My Tasks',
          'No_tasks_here':
              '🎉 No tasks here! \nTap the button and start adding tasks.',
          //tasks card
          "What would you like to do?": "What would you like to do?",
          'Can\'t Update!': 'Can\'t Update!',
          'Remaining Updates are 0.': 'Remaining Updates are 0.',
          'Update': 'Update',
          'Confirm Delete': 'Confirm Delete',
          'Are you sure you want to delete this task?':
              'Are you sure you want to delete this task?',
          'You will have': 'You will have',
          'delete(s) left.': 'delete(s) left.',
          'Cancel': 'Cancel',
          'Delete': 'Delete',
          'One-time Deadline:': 'One-time Deadline:',
          'Scheduled on:': 'Scheduled on:',
          'Repeats': 'Repeats',
          'Deadline:': 'Deadline:',
          'Verify Completion': 'Verify Completion',
          // notes screen
          'My Notes': 'My Notes',
          'No Notes here!': 'No Notes here!',
          'Tap the button and start adding notes.':
              'Tap the button and start adding notes.',
          //notes card
          'Are you sure you want to delete this Note?':
              'Are you sure you want to delete this Note?',
          // add notes screen
          "Add Note": "Add Note",
          "Title": "Title",
          "Content": "Content",
          //update notes screen
          'Edit Note': 'Edit Note',
          'Update Note': 'Update Note',
          //completed tasks
          'Completed Tasks': 'Completed Tasks',
          'No completed tasks yet.': 'No completed tasks yet.',
          'Finish some tasks and they will appear here.':
              'Finish some tasks and they will appear here.',
          //add tasks screen
          'Add New Task': 'Add New Task',
          'Task Type:': 'Task Type:',
          'One-Time': 'One-Time',
          'Scheduled': 'Scheduled',
          'Frequency': 'Frequency',
          'Everyday': 'Everyday',
          'Every Week': 'Every Week',
          'Choose Specific Dates': 'Choose Specific Dates',
          'Add Date & Time': 'Add Date & Time',
          'Pick Deadline': 'Pick Deadline',
          'theDeadline': 'Deadline',
          'Priority': 'Priority',
          'HIGH': 'high',
          'MEDIUM': 'medium',
          'LOW': 'low',
          //edit tasks screen
          'Edit Task': 'Edit Task',
          'Confirm Update': 'Confirm Update',
          'Are you sure you want to update this task?':
              'Are you sure you want to update this task?',
          'update(s) left.': 'update(s) left.',
          'UpdateTheTask': 'Update Task',
          //animation screen
          'Analyzing Complete!': 'Analyzing Complete!',
          'Analyzing...': 'Analyzing...',
          'Go Back': 'Go Back',
          'AI Says:': 'AI Says:',
          'Close': 'Close',
          'Show Analysis': 'Show Analysis',
          //Verify Task Completion Screen
          "Verify Task Completion": "Verify Task Completion",
          "Upload Image of Completed Task": "Upload Image of Completed Task",
          "Pick Image": "Pick Image",
          "No image selected.": "No image selected.",
          "Submit for Verification": "Submit for Verification",
          //drawer
          "My Account": "My Account",
          "My Achievements": "My Achievements",
          "About App": "About App",
          "Logout": "Logout",
          //about app screen
          'Version :': 'Version :',
          'What is Tasker?': 'What is Tasker?',
          'taskerDes':
              'Tasker is a simple yet powerful task management app designed to help you stay organized. With Tasker, you can create, edit, and complete tasks with ease, while receiving smart reminders to keep you on track.',
          'Why Tasker?': 'Why Tasker?',
          'taskerRes':
              'Whether it’s daily chores, school assignments, or work deadlines, Tasker makes it easier to manage everything in one place. Its lightweight design ensures you focus more on completing tasks than managing them.',
          'How does it work?': 'How does it work?',
          'taskerHow':
              'You can add tasks with deadlines, and Tasker will remind you when they’re due. If a task is completed, you’ll be congratulated 🎉. If you miss it, Tasker warns you so you never lose track of your goals.',
          'What’s Next?': 'What’s Next?',
          'taskerNext':
              'Future updates will include syncing across devices, advanced scheduling, and even smarter notifications to make sure you achieve your goals faster.',
          //splash screen
          "Achieve Your Goals": "Achieve Your Goals",
          // Change Password screen
          "Change Password": "Change Password",
          "oldPassword": "  Old Password",
          "newPassword": "  New Password",
          'Change Password Now': 'Change Password Now',
          //forget password screen
          "Forgot Password": "Forgot Password",
          "Enter your email": "Enter your email",
          "Send OTP": "Send OTP",
          //otp reset screen
          "Reset Password": "Reset Password",
          "  Enter New Password": "  Enter New Password",
          "Reset Password Now": "Reset Password",
          // warning strikes screen
          'Account Deleted!': 'Account Deleted!',
          'Warning!': 'Warning!',
          'accountDel':
              'Your account and all of its data has been deleted since you got',
          "Strikes": "Strikes.",
          'You already have': 'You already have',
          'Strikes left.': 'Strikes left.',
          // failed tasks screen
          'Failed At:': 'Failed At:',
          // task strikes screen
          'Tasks Strikes': 'Tasks Strikes',
          '🎉 No Strikes Yet!': '🎉 No Strikes Yet!',
          'Keep going!': 'Keep going!',
          // my account screen
          "Remaining Updates": "Remaining Updates",
          "Remaining Deletes": "Remaining Deletes",
          "Change Name": "Change Name",
          "Change Email": "Change Email",
          "Enter value": "Enter value",
          'Note': 'Note',
          'Field cannot be empty!': 'Field cannot be empty!',
          "Save": "Save",
          //landing screen
          'easAdd':
              'Easily add, edit, and track all your daily tasks in one place.',
          'Manage Your Tasks': 'Manage Your Tasks',
          'planTasks':
              'Plan your week and stay organized with smart scheduling.',
          'Stay Organized': 'Stay Organized',
          'neverMiss': 'Never miss a task with helpful reminders and alerts.',
          'Smart Notifications': 'Smart Notifications',
          'achGoals':
              'Achieve your goals and boost your productivity every day.',
          "Back": "Back",
          "Next": "Next",
          "Skip": "Skip",
          "Done": "Done",
          // signup screen
          "Create Your Account": "Create Your Account",
          "User Name": "User Name",
          "Email Address": "Email Address",
          "Password": "Password",
          "Confirm Password": "Confirm Password",
          'Already have an account?': 'Already have an account?',
          'Login': 'Login',
          "Signup": "Sign up",
          // login screen
          "ContinueWhere": "Continue where you left off!",
          'Email': 'Email',
          'Don\'t have an account?': 'Don\'t have an account?',
          'Forgot Password?': 'Forgot Password?',
          'Click Here': 'Click Here',
          //crud
          'An error occurred': 'An error occurred',
          "No network Connection.": "No network Connection.",
          "Not authenticated.": "Not authenticated.",
          "Deleted successfully": "Deleted successfully",
          //messages
          "exit app?": "exit app?",
          "Are you sure you want to leave?": "Are you sure you want to leave?",
          "No": "No",
          "Yes": "Yes",
          //controllers
          "Error": "Error",
          "Something went wrong": "Something went wrong",
          'No internet!': 'No internet!',
          'checkInternet':
              'Please check your internet connection then try again.',
          'No dates selected': 'No dates selected',
          'Loaded achievements from offline storage.':
              'Loaded achievements from offline storage.',
          'Name cannot be empty': 'Name cannot be empty',
          'Password cannot be empty': 'Password cannot be empty',
          'Weak Password! Must be at least 6 characters':
              'Weak Password! Must be at least 6 characters',
          'Email cannot be empty': 'Email cannot be empty',
          'Not a valid email!': 'Not a valid email!',
          'Success': 'Success',
          'Welcome to Tasker!': 'Welcome to Tasker!',
          'Passwords don\'t match!': 'Passwords don\'t match!',
          'Account created! Please verify your email.':
              'Account created! Please verify your email.',
          'New username can\'t be the same as old username.':
              'New username can\'t be the same as old username.',
          'Username updated successfully!': 'Username updated successfully!',
          "Failed to update user": "Failed to update user",
          "No Internet": "No Internet",
          "Check your connection and try again later.":
              "Check your connection and try again later.",
          'Loading Tasks from local Database.':
              'Loading Tasks from local Database.',
          'Content can\'t be empty.\nTitle can\'t be empty.':
              'Content can\'t be empty.\nTitle can\'t be empty.',
          'Loading Notes from local database.':
              'Loading Notes from local database.',
          "Note added successfully": "Note added successfully",
          'Please check your connection and try again.':
              'Please check your connection and try again.',
          "Note updated successfully": "Note updated successfully",
          "Note deleted successfully": "Note deleted successfully",
          "Follow These Rules:": "Follow These Rules:",
          'passRules':
              'Current Password can\'t be empty.\nNew Password can\'t be empty.\nEnter current password with length >= 6.\nnEnter current password with length >= 6.',
          "Password changed successfully": "Password changed successfully",
          'Email can\'t be empty, Email should Contain "@".':
              'Email can\'t be empty, Email should Contain "@".',
          "OTP Sent": "OTP Sent",
          "Check your email for the OTP": "Check your email for the OTP",
          'resPassRules':
              'Email can\'t be empty, Email should Contain "@".\nOTP mustn\'t be empty.\nNew Password can\'t be empty.\nNew Password Length must be greater then or equal to 6.',
          "Password reset successful": "Password reset successful",
          'Please fill all the required fields!':
              'Please fill all the required fields!',
          "Task added Successfully!": "Task added Successfully!",
          "Task updated Successfully!": "Task updated Successfully!",
          'No Image!': 'No Image!',
          'Please select an image.': 'Please select an image.',
          'Server error:': 'Server error:',
          //server
          'Unsupported HTTP method:': 'Unsupported HTTP method:',
          "Invalid verification link": "Invalid verification link",
          "Invalid or expired token": "Invalid or expired token",
          "Verification link expired": "Verification link expired",
          "Database error": "Database error",
          "✅ Email verified successfully! You can now log in.":
              "✅ Email verified successfully! You can now log in.",
          'This account is banned.': 'This account is banned.',
          'Account created! Please verify your email to activate your account.':
              'Account created! Please verify your email to activate your account.',
          'Invalid credentials': 'Invalid credentials',
          'Please verify your email first': 'Please verify your email first',
          "Logged out successfully": "Logged out successfully",
          'User not found': 'User not found',
          'No fields provided to update': 'No fields provided to update',
          'Email updated. Please verify your new email before logging in again.':
              'Email updated. Please verify your new email before logging in again.',
          'Error sending verification email':
              'Error sending verification email',
          'User updated successfully': 'User updated successfully',
          'User data deleted due to 3 strikes':
              'User data deleted due to 3 strikes',
          'User is safe': 'User is safe',
          'Both current and new password required':
              'Both current and new password required',
          'New password must be at least 6 characters':
              'New password must be at least 6 characters',
          'Current password incorrect': 'Current password incorrect',
          'New password cannot be the same as old password':
              'New password cannot be the same as old password',
          'Password updated successfully': 'Password updated successfully',
          "Email required": "Email required",
          "DB error: ": "DB error: ",
          "Failed to send email": "Failed to send email",
          "OTP sent to email": "OTP sent to email",
          "Email, OTP and new password required":
              "Email, OTP and new password required",
          "OTP not found": "OTP not found",
          "Invalid OTP": "Invalid OTP",
          "OTP expired": "OTP expired",
          "Failed to update password": "Failed to update password",
          'Title and content are required': 'Title and content are required',
          'Note not found or not owned by user':
              'Note not found or not owned by user',
          'Note updated': 'Note updated',
          'Note deleted': 'Note deleted',
          'Invalid deadline': 'Invalid deadline',
          'Custom tasks must include dates[]':
              'Custom tasks must include dates[]',
          'Invalid taskType/frequency': 'Invalid taskType/frequency',
          'Task added successfully': 'Task added successfully',
          'Task not found or not owned by user':
              'Task not found or not owned by user',
          'Task updated': 'Task updated',
          'Task deleted': 'Task deleted',
          "Failed to update notifications": "Failed to update notifications",
          "Notifications setting updated successfully":
              "Notifications setting updated successfully",
          "Notifications setting saved locally":
              "Notifications setting saved locally",
          "connection_closed_error": "Connection lost. Please try again.",
          "socket_error": "No internet connection or server unreachable.",
          "timeout_error": "Request timed out. Please try again.",
          "ssl_error": "Secure connection failed. Please check your network.",
          "format_error": "Invalid response format from server.",
          "client_error": "Client error occurred. Please try again.",
          'congrats': 'Congratulations!',
        },
        //*****
        // !Arabic
        //*****
        'ar': {
          //settings screen
          'settings': 'الإعدادات',
          'theme': 'المظهر',
          'light': 'فاتح',
          'dark': 'داكن',
          'language': 'اللغة',
          'notifications': 'الإشعارات',
          //homepage
          'Loading_name': 'يتم التحميل...',
          'Welcome': 'أهلاً بعودتك ',
          'Due Today': 'مهام اليوم',
          'Today’s Completed': 'مهام اكتملت اليوم',
          'Streak': 'المتتالية',
          'days': 'أيام',
          "Small steps every day lead to big results.":
              "الخطوات الصغيرة كل يوم تؤدي إلى نتائج كبيرة.",
          'See All': 'مشاهدة الكل',
          //achievements card
          'Progress: ': 'الاكتمال: ',
          'Completed': 'مكتمل',
          'Complete your tasks and get awards:': 'أكمل مهامك واحصل على جوائز:',
          "No_Achievements": "🎉 لم تتم إضافة أي إنجازات حتى الآن!",
          "In Progress": "قيد التنفيذ",
          //floating action button
          'Add_Task_ach': 'إضافة مهمة',
          'Add_Note_ach': 'إضافة ملاحظة',
          //schedule screen
          "Schedule": "جدول المهام",
          "No tasks scheduled for": "لا توجد مهام مجدولة ليوم",
          //incomplete tasks screen
          'My Tasks': 'مهام قيد التنفيذ',
          'No_tasks_here':
              '🎉 لا توجد مهام هنا! \nانقر فوق الزر وابدأ بإضافة المهام.',
          //tasks card
          "What would you like to do?": "ماذا تريد أن تفعل?",
          'Can\'t Update!': 'لا يمكن التحديث!',
          'Remaining Updates are 0.': 'التحديثات المتبقية هي 0.',
          'Update': 'تحديث',
          'Confirm Delete': 'تأكيد الحذف',
          'Are you sure you want to delete this task?':
              'هل أنت متأكد أنك تريد حذف هذه المهمة?',
          'You will have': 'سيكون لديك',
          'delete(s) left.': 'عمليات حذف متبقية',
          'Cancel': 'إلغاء',
          'Delete': 'حذف',
          'One-time Deadline:': 'مهمة لمرة واحدة:',
          'Scheduled on:': 'من المقرر في:',
          'Repeats': 'يكرر',
          'Deadline:': 'الموعد النهائي:',
          'Verify Completion': 'التحقق من الإكتمال',
          // notes screen
          'My Notes': 'ملاحظاتي',
          'No Notes here!': 'لا يوجد ملاحظات هنا!',
          'Tap the button and start adding notes.':
              'اضغط على الزر وابدأ بإضافة الملاحظات.',
          //notes card
          'Are you sure you want to delete this Note?':
              'هل أنت متأكد أنك تريد حذف هذه الملاحظة؟',
          //add notes screen
          "Add Note": "إضافة ملاحظة",
          "Title": "العنوان",
          "Content": "المحتوى",
          //update notes screen
          'Edit Note': 'تعديل الملاحظة',
          'Update Note': 'تحديث الملاحظة',
          //completed tasks
          'Completed Tasks': 'المهام المكتملة',
          'No completed tasks yet.': 'لم يتم إكمال أي مهام بعد.',
          'Finish some tasks and they will appear here.':
              'قم بإكمال بعض المهام وسوف تظهر هنا.',
          //add tasks screen
          'Add New Task': 'إضافة مهمة جديدة',
          'Task Type:': 'نوع المهمة:',
          'One-Time': 'لمرة واحدة',
          'Scheduled': 'مجدولة',
          'Frequency': 'التكرار',
          'Everyday': 'كل يوم',
          'Every Week': 'كل اسبوع',
          'Choose Specific Dates': 'اختر مواعيد محددة',
          'Add Date & Time': 'أضف التاريخ والوقت',
          'Pick Deadline': 'اختر الموعد النهائي',
          'theDeadline': 'الموعد النهائي',
          'Priority': 'الأولوية',
          'HIGH': 'عالي',
          'MEDIUM': 'وسط',
          'LOW': 'منخفض',
          //edit tasks screen
          'Edit Task': 'تعديل المهمة',
          'Confirm Update': 'تأكيد التحديث',
          'Are you sure you want to update this task?':
              'هل أنت متأكد أنك تريد تحديث هذه المهمة؟',
          'update(s) left.': 'تحديثات المتبقية.',
          'UpdateTheTask': 'تحديث المهمة',
          //animation screen
          'Analyzing Complete!': 'تم التحليل بالكامل!',
          'Analyzing...': 'جاري التحليل الآن...',
          'Go Back': 'العودة',
          'AI Says:': 'يقول الذكاء الاصطناعي:',
          'Close': 'أغلق',
          'Show Analysis': 'عرض التحليل',
          //Verify Task Completion Screen
          "Verify Task Completion": "التحقق من اكتمال المهمة",
          "Upload Image of Completed Task": "حمل صورة للمهمة المكتملة",
          "Pick Image": "اختر الصورة",
          "No image selected.": "لم يتم تحديد أي صورة.",
          "Submit for Verification": "إرسال للتحقق",
          //drawer
          "My Account": "ملفي الشخصي",
          "My Achievements": "إنجازاتي",
          "About App": "حول التطبيق",
          "Logout": "تسجيل الخروج",
          //about app screen
          'Version :': 'الإصدار :',
          'What is Tasker?': 'ما هو تطبيق  تاسكر؟',
          'taskerDes':
              'تاسكر تطبيق إدارة مهام بسيط وفعّال، مصمم لمساعدتك على تنظيم مهامك. مع تاسكر، يمكنك إنشاء المهام وتعديلها وإكمالها بسهولة، مع تلقي تذكيرات ذكية تُبقيك على المسار الصحيح.',
          'Why Tasker?': 'لماذا تاسكر؟',
          'taskerRes':
              'سواءً كانت مهامًا يومية، أو واجبات مدرسية، أو مواعيد عمل نهائية، يُسهّل تطبيق  تاسكر إدارة كل شيء في مكان واحد. تصميمه خفيف الوزن يضمن لك التركيز على إنجاز المهام أكثر من إدارتها.',
          'How does it work?': 'كيف يعمل تطبيق  تاسكر؟',
          'taskerHow':
              'يمكنك إضافة مهام بمواعيد نهائية، وسيُذكرك  تاسكر بموعد استحقاقها. إذا أنجزت مهمة، ستتلقى تهنئة 🎉. إذا فاتتك، يُنبهك Tasker حتى لا تفقد أهدافك أبدًا.',
          'What’s Next?': 'ما هو التالي في المستقبل؟',
          'taskerNext':
              'ستتضمن التحديثات المستقبلية المزامنة عبر الأجهزة، والجدولة المتقدمة، وحتى الإشعارات الأكثر ذكاءً للتأكد من تحقيق أهدافك بشكل أسرع.',
          //splash screen
          "Achieve Your Goals": "حقق أهدافك مع تطبيق تاسكر",
          // Change Password screen
          "Change Password": "تغيير كلمة المرور",
          "oldPassword": "  كلمة المرور القديمة",
          "newPassword": "  كلمة المرور الجديدة",
          'Change Password Now': 'غيُر كلمة المرور',
          //forget password screen
          "Forgot Password": "نسيت كلمة المرور",
          "Enter your email": "أدخل بريدك الإلكتروني",
          "Send OTP": "إرسال رمز التحقق",
          //otp reset screen
          "Reset Password": "إعادة تعيين كلمة المرور",
          "  Enter New Password": "  أدخل كلمة المرور الجديدة",
          "Reset Password Now": "إعادة تعيين",
          // warning strikes screen
          'Account Deleted!': 'تم حذف الحساب!',
          'Warning!': 'تحذير!',
          'accountDel': 'لقد تم حذف حسابك وجميع بياناته بسبب حصولك على',
          "Strikes": "مخالفات.",
          'You already have': 'لديك بالفعل',
          'Strikes left.': 'مخالفات متبقية.',
          // failed tasks screen
          'Failed At:': 'وقت الفشل:',
          // task strikes screen
          'Tasks Strikes': 'مخالفات المهام',
          '🎉 No Strikes Yet!': '🎉 لا توجد مخالفات حتى الآن!',
          'Keep going!': 'استمر!',
          // my account screen
          "Remaining Updates": "التحديثات المتبقية",
          "Remaining Deletes": "عمليات الحذف المتبقية",
          "Change Name": "تغيير الاسم",
          "Change Email": "تغيير البريد الإلكتروني",
          "Enter value": "أدخل القيمة",
          'Note': 'ملاحظة',
          'Field cannot be empty!': 'لا يمكن أن يكون الحقل فارغا!',
          "Save": "حفظ",
          //landing screen
          'easAdd':
              'يمكنك بسهولة إضافة مهامك اليومية وتحريرها وتتبعها في مكان واحد.',
          'Manage Your Tasks': 'قم بإدارة مهامك',
          'planTasks': 'خطط لأسبوعك وحافظ على تنظيمك من خلال الجدولة الذكية.',
          'Stay Organized': 'ابق منظمًا',
          'neverMiss': 'لا تفوت أي مهمة أبدًا مع التذكيرات والتنبيهات المفيدة.',
          'Smart Notifications': 'الإشعارات الذكية',
          'achGoals': 'حقق أهدافك وعزز إنتاجيتك كل يوم.',
          "Back": "السابق",
          "Next": "التالي",
          "Skip": "تخطي",
          "Done": "اكتمل",
          // signup screen
          "Create Your Account": "أنشىء حسابك",
          "User Name": "اسم المستخدم",
          "Email Address": "عنوان البريد الإلكتروني",
          "Password": "كلمة المرور",
          "Confirm Password": "تأكيد كلمة المرور",
          'Already have an account?': 'هل لديك حساب بالفعل؟',
          'Login': 'تسجيل الدخول',
          "Signup": "إنشاء حساب",
          // login screen
          "ContinueWhere": "استمر ​​من حيث توقفت!",
          'Email': 'البريد الإلكتروني',
          'Don\'t have an account?': 'ليس لديك حساب؟',
          'Forgot Password?': 'هل نسيت كلمة السر؟',
          'Click Here': 'انقر هنا',
          //crud
          'An error occurred': 'حدث خطأ',
          "No network Connection.": "لا يوجد اتصال بالشبكة.",
          "Not authenticated.": "غير مصرح للوصول.",
          "Deleted successfully": "تم الحذف بنجاح",
          //messages
          "exit app?": "الخروج من التطبيق؟",
          "Are you sure you want to leave?": "هل أنت متأكد أنك تريد المغادرة؟",
          "No": "لا",
          "Yes": "نعم",
          //controllers
          "Error": "خطأ",
          "Something went wrong": "حدث خطأ ما",
          'No internet!': 'لا يوجد إنترنت!',
          'checkInternet':
              'يرجى التحقق من اتصالك بالإنترنت ثم المحاولة مرة أخرى.',
          'No dates selected': 'لم يتم اختيار أي تواريخ',
          'Loaded achievements from offline storage.':
              'تم تحميل الإنجازات من التخزين غير المتصل.',
          'Name cannot be empty': 'لا يمكن أن يكون الاسم فارغًا',
          'Password cannot be empty': 'لا يمكن أن تكون كلمة المرور فارغة',
          'Weak Password! Must be at least 6 characters':
              'كلمة مرور ضعيفة! يجب أن تتكون من 6 أحرف على الأقل',
          'Email cannot be empty': 'لا يمكن أن يكون البريد الإلكتروني فارغًا',
          'Not a valid email!': 'بريد إلكتروني غير صالح!',
          'Success': 'نجاح',
          'Welcome to Tasker!': 'مرحبًا بك في Tasker!',
          'Passwords don\'t match!': 'كلمات المرور غير متطابقة!',
          'Account created! Please verify your email.':
              'تم إنشاء الحساب! يرجى التحقق من بريدك الإلكتروني.',
          'New username can\'t be the same as old username.':
              'لا يمكن أن يكون اسم المستخدم الجديد نفس اسم المستخدم القديم.',
          'Username updated successfully!': 'تم تحديث اسم المستخدم بنجاح!',
          "Failed to update user": "فشل تحديث المستخدم",
          "No Internet": "لا يوجد إنترنت",
          "Check your connection and try again later.":
              "تحقق من اتصالك وحاول مرة أخرى لاحقًا.",
          'Loading Tasks from local Database.':
              'جارٍ تحميل المهام من قاعدة البيانات المحلية.',
          'Content can\'t be empty.\nTitle can\'t be empty.':
              'لا يمكن أن يكون المحتوى فارغًا.\nلا يمكن أن يكون العنوان فارغًا.',
          'Loading Notes from local database.':
              'جارٍ تحميل الملاحظات من قاعدة البيانات المحلية.',
          "Note added successfully": "تمت إضافة الملاحظة بنجاح",
          'Please check your connection and try again.':
              'يرجى التحقق من اتصالك والمحاولة مرة أخرى.',
          "Note updated successfully": "تم تحديث الملاحظة بنجاح",
          "Note deleted successfully": "تم حذف الملاحظة بنجاح",
          "Follow These Rules:": "اتبع هذه القواعد:",
          'passRules':
              'لا يمكن أن تكون كلمة المرور الحالية فارغة.\nلا يمكن أن تكون كلمة المرور الجديدة فارغة.\nيجب أن يكون طول كلمة المرور الحالية >= 6.\nيجب أن يكون طول كلمة المرور الجديدة >= 6.',
          "Password changed successfully": "تم تغيير كلمة المرور بنجاح",
          'Email can\'t be empty, Email should Contain "@".':
              'لا يمكن أن يكون البريد الإلكتروني فارغًا، ويجب أن يحتوي على "@".',
          "OTP Sent": "تم إرسال رمز التحقق",
          "Check your email for the OTP":
              "تحقق من بريدك الإلكتروني للحصول على رمز التحقق",
          'resPassRules':
              'لا يمكن أن يكون البريد الإلكتروني فارغًا، ويجب أن يحتوي على "@".\nلا يجب أن يكون رمز التحقق فارغًا.\nلا يمكن أن تكون كلمة المرور الجديدة فارغة.\nيجب أن يكون طول كلمة المرور الجديدة أكبر من أو يساوي 6.',
          "Password reset successful": "تمت إعادة تعيين كلمة المرور بنجاح",
          'Please fill all the required fields!':
              'يرجى ملء جميع الحقول المطلوبة!',
          "Task added Successfully!": "تمت إضافة المهمة بنجاح!",
          "Task updated Successfully!": "تم تحديث المهمة بنجاح!",
          'No Image!': 'لا توجد صورة!',
          'Please select an image.': 'يرجى اختيار صورة.',
          'Server error:': 'خطأ في الخادم:',
          //server
          'Unsupported HTTP method:': 'طريقة HTTP غير مدعومة:',
          "Invalid verification link": "رابط التحقق غير صالح",
          "Invalid or expired token": "الرمز غير صالح أو منتهي الصلاحية",
          "Verification link expired": "انتهت صلاحية رابط التحقق",
          "Database error": "خطأ في قاعدة البيانات",
          "✅ Email verified successfully! You can now log in.":
              "✅ تم التحقق من البريد الإلكتروني بنجاح! يمكنك الآن تسجيل الدخول.",
          'This account is banned.': 'تم حظر هذا الحساب.',
          'Account created! Please verify your email to activate your account.':
              'تم إنشاء الحساب! يرجى التحقق من بريدك الإلكتروني لتفعيل الحساب.',
          'Invalid credentials': 'البيانات المدخلة غير صحيحة',
          'Please verify your email first':
              'يرجى التحقق من بريدك الإلكتروني أولاً',
          "Logged out successfully": "تم تسجيل الخروج بنجاح",
          'User not found': 'المستخدم غير موجود',
          'No fields provided to update': 'لم يتم تقديم أي حقول للتحديث',
          'Email updated. Please verify your new email before logging in again.':
              'تم تحديث البريد الإلكتروني. يرجى التحقق من بريدك الجديد قبل تسجيل الدخول مرة أخرى.',
          'Error sending verification email': 'حدث خطأ أثناء إرسال بريد التحقق',
          'User updated successfully': 'تم تحديث بيانات المستخدم بنجاح',
          'User data deleted due to 3 strikes':
              'تم حذف بيانات المستخدم بسبب 3 مخالفات',
          'User is safe': 'المستخدم في أمان',
          'Both current and new password required':
              'كلا من كلمة المرور الحالية والجديدة مطلوبان',
          'New password must be at least 6 characters':
              'يجب أن تتكون كلمة المرور الجديدة من 6 أحرف على الأقل',
          'Current password incorrect': 'كلمة المرور الحالية غير صحيحة',
          'New password cannot be the same as old password':
              'لا يمكن أن تكون كلمة المرور الجديدة نفس كلمة المرور القديمة',
          'Password updated successfully': 'تم تحديث كلمة المرور بنجاح',
          "Email required": "البريد الإلكتروني مطلوب",
          "DB error: ": "خطأ في قاعدة البيانات: ",
          "Failed to send email": "فشل في إرسال البريد الإلكتروني",
          "OTP sent to email": "تم إرسال رمز التحقق إلى البريد الإلكتروني",
          "Email, OTP and new password required":
              "البريد الإلكتروني، رمز التحقق، وكلمة المرور الجديدة مطلوبة",
          "OTP not found": "رمز التحقق غير موجود",
          "Invalid OTP": "رمز التحقق غير صالح",
          "OTP expired": "انتهت صلاحية رمز التحقق",
          "Failed to update password": "فشل تحديث كلمة المرور",
          'Title and content are required': 'العنوان والمحتوى مطلوبان',
          'Note not found or not owned by user':
              'الملاحظة غير موجودة أو لا يملكها المستخدم',
          'Note updated': 'تم تحديث الملاحظة',
          'Note deleted': 'تم حذف الملاحظة',
          'Invalid deadline': 'الموعد النهائي غير صالح',
          'Custom tasks must include dates[]':
              'يجب أن تتضمن المهام المخصصة قائمة التواريخ []',
          'Invalid taskType/frequency': 'نوع المهمة أو التكرار غير صالح',
          'Task added successfully': 'تمت إضافة المهمة بنجاح',
          'Task not found or not owned by user':
              'المهمة غير موجودة أو لا يملكها المستخدم',
          'Task updated': 'تم تحديث المهمة',
          'Task deleted': 'تم حذف المهمة',
          "Failed to update notifications": "فشل تحديث إعدادات الإشعارات",
          "Notifications setting updated successfully":
              "تم تحديث إعدادات الإشعارات بنجاح",
          "Notifications setting saved locally":
              "تم حفظ إعدادات الإشعارات محليًا",
          "connection_closed_error": "انقطع الاتصال. يرجى المحاولة مرة أخرى.",
          "socket_error": "لا يوجد اتصال بالإنترنت أو الخادم غير متاح.",
          "timeout_error": "انتهت مهلة الطلب. حاول مرة أخرى.",
          "ssl_error": "فشل الاتصال الآمن. يرجى التحقق من الشبكة.",
          "format_error": "تنسيق الاستجابة من الخادم غير صالح.",
          "client_error": "حدث خطأ في العميل. حاول مرة أخرى.",
          'congrats': 'تهانينا!',
        },
      };
}
