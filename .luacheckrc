local a={}local b={read_only=false}local c={read_only=false,other_fields=true}local d={read_only=true}local function e(f)local g={}for h,i in ipairs(f)do g[i]=a end;return{fields=g}end;local j=e({"Value","Name"})local function k(f)local g={}for h,i in ipairs(f)do g[i]=j end;g["GetEnumItems"]=d;return{fields=g}end;stds.roblox={globals={script={other_fields=true,fields={Source=b,GetHash=b,Disabled=b,LinkedSource=b,CurrentEditor=c,Archivable=b,ClassName=d,DataCost=d,Name=b,Parent=c,RobloxLocked=b,ClearAllChildren=b,Clone=b,Destroy=b,FindFirstAncestor=b,FindFirstAncestorOfClass=b,FindFirstAncestorWhichIsA=b,FindFirstChild=b,FindFirstChildOfClass=b,FindFirstChildWhichIsA=b,GetChildren=b,GetDebugId=b,GetDescendants=b,GetFullName=b,GetPropertyChangedSignal=b,IsA=b,IsAncestorOf=b,IsDescendantOf=b,WaitForChild=b,AncestryChanged=b,Changed=b,ChildAdded=b,ChildRemoved=b,DescendantAdded=b,DescendantRemoving=b}},game={other_fields=true,fields={CreatorId=d,CreatorType=d,GameId=d,GearGenreSetting=d,Genre=d,IsSFFlagsLoaded=d,JobId=d,PlaceId=d,PlaceVersion=d,PrivateServerId=d,PrivateServerOwnerId=d,Workspace=d,BindToClose=b,GetJobIntervalPeakFraction=b,GetJobTimePeakFraction=b,GetJobsExtendedStats=b,GetJobsInfo=b,GetObjects=b,IsGearTypeAllowed=b,IsLoaded=b,Load=b,OpenScreenshotsFolder=b,OpenVideosFolder=b,ReportInGoogleAnalytics=b,SetPlaceId=b,SetUniverseId=b,Shutdown=b,HttpGetAsync=b,HttpPostAsync=b,GraphicsQualityChangeRequest=b,Loaded=b,ScreenshotReady=b,FindService=b,GetService=b,Close=b,CloseLate=b,ServiceAdded=b,ServiceRemoving=b,Archivable=b,ClassName=d,DataCost=d,Name=b,Parent=c,RobloxLocked=b,ClearAllChildren=b,Clone=b,Destroy=b,FindFirstAncestor=b,FindFirstAncestorOfClass=b,FindFirstAncestorWhichIsA=b,FindFirstChild=b,FindFirstChildOfClass=b,FindFirstChildWhichIsA=b,GetChildren=b,GetDebugId=b,GetDescendants=b,GetFullName=b,GetPropertyChangedSignal=b,IsA=b,IsAncestorOf=b,IsDescendantOf=b,WaitForChild=b,AncestryChanged=b,Changed=b,ChildAdded=b,ChildRemoved=b,DescendantAdded=b,DescendantRemoving=b}},workspace={other_fields=true,fields={AllowThirdPartySales=b,AutoJointsMode=b,CurrentCamera=c,DistributedGameTime=b,FallenPartsDestroyHeight=b,FilteringEnabled=b,Gravity=b,StreamingEnabled=b,StreamingMinRadius=b,StreamingTargetRadius=b,TemporaryLegacyPhysicsSolverOverride=b,Terrain=d,BreakJoints=b,ExperimentalSolverIsEnabled=b,FindPartOnRay=b,FindPartOnRayWithIgnoreList=b,FindPartOnRayWithWhitelist=b,FindPartsInRegion3=b,FindPartsInRegion3WithIgnoreList=b,FindPartsInRegion3WithWhiteList=b,GetNumAwakeParts=b,GetPhysicsThrottling=b,GetRealPhysicsFPS=b,IsRegion3Empty=b,IsRegion3EmptyWithIgnoreList=b,JoinToOutsiders=b,MakeJoints=b,PGSIsEnabled=b,SetPhysicsThrottleEnabled=b,UnjoinFromOutsiders=b,ZoomToExtents=b,PrimaryPart=c,BreakJoints=b,GetBoundingBox=b,GetExtentsSize=b,GetPrimaryPartCFrame=b,MakeJoints=b,MoveTo=b,SetPrimaryPartCFrame=b,TranslateBy=b,Archivable=b,ClassName=d,DataCost=d,Name=b,Parent=c,RobloxLocked=b,ClearAllChildren=b,Clone=b,Destroy=b,FindFirstAncestor=b,FindFirstAncestorOfClass=b,FindFirstAncestorWhichIsA=b,FindFirstChild=b,FindFirstChildOfClass=b,FindFirstChildWhichIsA=b,GetChildren=b,GetDebugId=b,GetDescendants=b,GetFullName=b,GetPropertyChangedSignal=b,IsA=b,IsAncestorOf=b,IsDescendantOf=b,WaitForChild=b,AncestryChanged=b,Changed=b,ChildAdded=b,ChildRemoved=b,DescendantAdded=b,DescendantRemoving=b}}},read_globals={delay=a,settings=a,spawn=a,tick=a,time=a,typeof=a,version=a,wait=a,warn=a,math=e({"abs","acos","asin","atan","atan2","ceil","clamp","cos","cosh","deg","exp","floor","fmod","frexp","ldexp","log","log10","max","min","modf","noise","pow","rad","random","randomseed","sign","sin","sinh","sqrt","tan","tanh","huge","pi"}),debug=e({"traceback","profilebegin","profileend"}),utf8=e({"char","codes","codepoint","len","offset","graphemes","nfcnormalize","nfdnormalize","charpattern"}),Axes=e({"new"}),BrickColor=e({"new","palette","random","White","Gray","DarkGray","Black","Red","Yellow","Green","Blue"}),CFrame=e({"new","fromEulerAnglesXYZ","Angles","fromOrientation","fromAxisAngle","fromMatrix"}),Color3=e({"new","fromRGB","fromHSV","toHSV"}),ColorSequence=e({"new"}),ColorSequenceKeypoint=e({"new"}),DockWidgetPluginGuiInfo=e({"new"}),Enums=e({"GetEnums"}),Faces=e({"new"}),Instance=e({"new"}),NumberRange=e({"new"}),NumberSequence=e({"new"}),NumberSequenceKeypoint=e({"new"}),PhysicalProperties=e({"new"}),Random=e({"new"}),Ray=e({"new"}),Rect=e({"new"}),Region3=e({"new"}),Region3int16=e({"new"}),TweenInfo=e({"new"}),UDim=e({"new"}),UDim2=e({"new"}),Vector2=e({"new"}),Vector2int16=e({"new"}),Vector3=e({"new","FromNormalId","FromAxis"}),Vector3int16=e({"new"}),Enum={readonly=true,fields={ActionType=k({"Nothing","Pause","Lose","Draw","Win"}),ActuatorRelativeTo=k({"Attachment0","Attachment1","World"}),ActuatorType=k({"None","Motor","Servo"}),AlignType=k({"Parallel","Perpendicular"}),AnimationPriority=k({"Idle","Movement","Action","Core"}),AppShellActionType=k({"None","OpenApp","TapChatTab","TapConversationEntry","TapAvatarTab","ReadConversation","TapGamePageTab","TapHomePageTab","GamePageLoaded","HomePageLoaded","AvatarEditorPageLoaded"}),AspectType=k({"FitWithinMaxSize","ScaleWithParentSize"}),AssetType=k({"Image","TeeShirt","Audio","Mesh","Lua","Hat","Place","Model","Shirt","Pants","Decal","Head","Face","Gear","Badge","Animation","Torso","RightArm","LeftArm","LeftLeg","RightLeg","Package","GamePass","Plugin","MeshPart","HairAccessory","FaceAccessory","NeckAccessory","ShoulderAccessory","FrontAccessory","BackAccessory","WaistAccessory","ClimbAnimation","DeathAnimation","FallAnimation","IdleAnimation","JumpAnimation","RunAnimation","SwimAnimation","WalkAnimation","PoseAnimation","EarAccessory","EyeAccessory"}),AutoJointsMode=k({"Default","Explicit","LegacyImplicit"}),AvatarContextMenuOption=k({"Friend","Chat","Emote"}),AvatarJointPositionType=k({"Fixed","ArtistIntent"}),Axis=k({"X","Y","Z"}),BinType=k({"Script","GameTool","Grab","Clone","Hammer"}),BodyPart=k({"Head","Torso","LeftArm","RightArm","LeftLeg","RightLeg"}),BodyPartR15=k({"Head","UpperTorso","LowerTorso","LeftFoot","LeftLowerLeg","LeftUpperLeg","RightFoot","RightLowerLeg","RightUpperLeg","LeftHand","LeftLowerArm","LeftUpperArm","RightHand","RightLowerArm","RightUpperArm","RootPart","Unknown"}),Button=k({"Jump","Dismount"}),ButtonStyle=k({"Custom","RobloxButtonDefault","RobloxButton","RobloxRoundButton","RobloxRoundDefaultButton","RobloxRoundDropdownButton"}),CameraMode=k({"Classic","LockFirstPerson"}),CameraPanMode=k({"Classic","EdgeBump"}),CameraType=k({"Fixed","Watch","Attach","Track","Follow","Custom","Scriptable","Orbital"}),CellBlock=k({"Solid","VerticalWedge","CornerWedge","InverseCornerWedge","HorizontalWedge"}),CellMaterial=k({"Empty","Grass","Sand","Brick","Granite","Asphalt","Iron","Aluminum","Gold","WoodPlank","WoodLog","Gravel","CinderBlock","MossyStone","Cement","RedPlastic","BluePlastic","Water"}),CellOrientation=k({"NegZ","X","Z","NegX"}),CenterDialogType=k({"UnsolicitedDialog","PlayerInitiatedDialog","ModalDialog","QuitDialog"}),ChatCallbackType=k({"OnCreatingChatWindow","OnClientSendingMessage","OnClientFormattingMessage","OnServerReceivingMessage"}),ChatColor=k({"Blue","Green","Red","White"}),ChatMode=k({"Menu","TextAndMenu"}),ChatPrivacyMode=k({"AllUsers","NoOne","Friends"}),ChatStyle=k({"Classic","Bubble","ClassicAndBubble"}),CollisionFidelity=k({"Default","Hull","Box"}),ComputerCameraMovementMode=k({"Default","Follow","Classic","Orbital"}),ComputerMovementMode=k({"Default","KeyboardMouse","ClickToMove"}),ConnectionError=k({"OK","DisconnectErrors","DisconnectBadhash","DisconnectSecurityKeyMismatch","DisconnectNewSecurityKeyMismatch","DisconnectProtocolMismatch","DisconnectReceivePacketError","DisconnectReceivePacketStreamError","DisconnectSendPacketError","DisconnectIllegalTeleport","DisconnectDuplicatePlayer","DisconnectDuplicateTicket","DisconnectTimeout","DisconnectLuaKick","DisconnectOnRemoteSysStats","DisconnectHashTimeout","DisconnectCloudEditKick","DisconnectPlayerless","DisconnectEvicted","DisconnectDevMaintenance","DisconnectRobloxMaintenance","DisconnectRejoin","DisconnectConnectionLost","DisconnectIdle","DisconnectRaknetErrors","DisconnectWrongVersion","PlacelaunchErrors","PlacelaunchDisabled","PlacelaunchError","PlacelaunchGameEnded","PlacelaunchGameFull","PlacelaunchUserLeft","PlacelaunchRestricted","PlacelaunchUnauthorized","PlacelaunchFlooded","PlacelaunchHashExpired","PlacelaunchHashException","PlacelaunchPartyCannotFit","PlacelaunchHttpError","PlacelaunchCustomMessage","PlacelaunchOtherError","TeleportErrors","TeleportFailure","TeleportGameNotFound","TeleportGameEnded","TeleportGameFull","TeleportUnauthorized","TeleportFlooded","TeleportIsTeleporting"}),ConnectionState=k({"Connected","Disconnected"}),ContextActionPriority=k({"Low","Medium","Default","High"}),ContextActionResult=k({"Pass","Sink"}),ControlMode=k({"MouseLockSwitch","Classic"}),CoreGuiType=k({"PlayerList","Health","Backpack","Chat","All"}),CreatorType=k({"User","Group"}),CurrencyType=k({"Default","Robux","Tix"}),CustomCameraMode=k({"Default","Follow","Classic"}),DEPRECATED_DebuggerDataModelPreference=k({"Server","Client"}),DataStoreRequestType=k({"GetAsync","SetIncrementAsync","UpdateAsync","GetSortedAsync","SetIncrementSortedAsync","OnUpdate"}),DevCameraOcclusionMode=k({"Zoom","Invisicam"}),DevComputerCameraMovementMode=k({"UserChoice","Classic","Follow","Orbital"}),DevComputerMovementMode=k({"UserChoice","KeyboardMouse","ClickToMove","Scriptable"}),DevTouchCameraMovementMode=k({"UserChoice","Classic","Follow","Orbital"}),DevTouchMovementMode=k({"UserChoice","Thumbstick","DPad","Thumbpad","ClickToMove","Scriptable","DynamicThumbstick"}),DeveloperMemoryTag=k({"Internal","HttpCache","Instances","Signals","LuaHeap","Script","PhysicsCollision","PhysicsParts","GraphicsSolidModels","GraphicsMeshParts","GraphicsParticles","GraphicsParts","GraphicsSpatialHash","GraphicsTerrain","GraphicsTexture","GraphicsTextureCharacter","Sounds","StreamingSounds","TerrainVoxels","Gui","Animation","Navigation"}),DialogBehaviorType=k({"SinglePlayer","MultiplePlayers"}),DialogPurpose=k({"Quest","Help","Shop"}),DialogTone=k({"Neutral","Friendly","Enemy"}),DominantAxis=k({"Width","Height"}),EasingDirection=k({"In","Out","InOut"}),EasingStyle=k({"Linear","Sine","Back","Quad","Quart","Quint","Bounce","Elastic"}),ElasticBehavior=k({"WhenScrollable","Always","Never"}),EnviromentalPhysicsThrottle=k({"DefaultAuto","Disabled","Always","Skip2","Skip4","Skip8","Skip16"}),ErrorReporting=k({"DontReport","Prompt","Report"}),ExplosionType=k({"NoCraters","Craters","CratersAndDebris"}),FillDirection=k({"Horizontal","Vertical"}),FilterResult=k({"Rejected","Accepted"}),Font=k({"Legacy","Arial","ArialBold","SourceSans","SourceSansBold","SourceSansSemibold","SourceSansLight","SourceSansItalic","Bodoni","Garamond","Cartoon","Code","Highway","SciFi","Arcade","Fantasy","Antique","Gotham","GothamSemibold","GothamBold","GothamBlack"}),FontSize=k({"Size8","Size9","Size10","Size11","Size12","Size14","Size18","Size24","Size36","Size48","Size28","Size32","Size42","Size60","Size96"}),FormFactor=k({"Symmetric","Brick","Plate","Custom"}),FrameStyle=k({"Custom","ChatBlue","RobloxSquare","RobloxRound","ChatGreen","ChatRed","DropShadow"}),FramerateManagerMode=k({"Automatic","On","Off"}),FriendRequestEvent=k({"Issue","Revoke","Accept","Deny"}),FriendStatus=k({"Unknown","NotFriend","Friend","FriendRequestSent","FriendRequestReceived"}),FunctionalTestResult=k({"Passed","Warning","Error"}),GameAvatarType=k({"R6","R15","PlayerChoice"}),GearGenreSetting=k({"AllGenres","MatchingGenreOnly"}),GearType=k({"MeleeWeapons","RangedWeapons","Explosives","PowerUps","NavigationEnhancers","MusicalInstruments","SocialItems","BuildingTools","Transport"}),Genre=k({"All","TownAndCity","Fantasy","SciFi","Ninja","Scary","Pirate","Adventure","Sports","Funny","WildWest","War","SkatePark","Tutorial"}),GraphicsMode=k({"Automatic","Direct3D9","Direct3D11","OpenGL","Metal","Vulkan","NoGraphics"}),HandlesStyle=k({"Resize","Movement"}),HorizontalAlignment=k({"Center","Left","Right"}),HoverAnimateSpeed=k({"VerySlow","Slow","Medium","Fast","VeryFast"}),HttpCachePolicy=k({"None","Full","DataOnly","Default","InternalRedirectRefresh"}),HttpContentType=k({"ApplicationJson","ApplicationXml","ApplicationUrlEncoded","TextPlain","TextXml"}),HttpError=k({"OK","InvalidUrl","DnsResolve","ConnectFail","OutOfMemory","TimedOut","TooManyRedirects","InvalidRedirect","NetFail","Aborted","SslConnectFail","Unknown"}),HttpRequestType=k({"Default","MarketplaceService","Players","Chat","Avatar","Analytics","Localization"}),HumanoidDisplayDistanceType=k({"Viewer","Subject","None"}),HumanoidHealthDisplayType=k({"DisplayWhenDamaged","AlwaysOn","AlwaysOff"}),HumanoidRigType=k({"R6","R15"}),HumanoidStateType=k({"FallingDown","Running","RunningNoPhysics","Climbing","StrafingNoPhysics","Ragdoll","GettingUp","Jumping","Landed","Flying","Freefall","Seated","PlatformStanding","Dead","Swimming","Physics","None"}),InOut=k({"Edge","Inset","Center"}),InfoType=k({"Asset","Product","GamePass"}),InitialDockState=k({"Top","Bottom","Left","Right","Float"}),InputType=k({"NoInput","Constant","Sin"}),JointCreationMode=k({"All","Surface","None"}),JointType=k({"None","Rotate","RotateP","RotateV","Glue","Weld","Snap"}),KeyCode=k({"Unknown","Backspace","Tab","Clear","Return","Pause","Escape","Space","QuotedDouble","Hash","Dollar","Percent","Ampersand","Quote","LeftParenthesis","RightParenthesis","Asterisk","Plus","Comma","Minus","Period","Slash","Zero","One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Colon","Semicolon","LessThan","Equals","GreaterThan","Question","At","LeftBracket","BackSlash","RightBracket","Caret","Underscore","Backquote","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","LeftCurly","Pipe","RightCurly","Tilde","Delete","KeypadZero","KeypadOne","KeypadTwo","KeypadThree","KeypadFour","KeypadFive","KeypadSix","KeypadSeven","KeypadEight","KeypadNine","KeypadPeriod","KeypadDivide","KeypadMultiply","KeypadMinus","KeypadPlus","KeypadEnter","KeypadEquals","Up","Down","Right","Left","Insert","Home","End","PageUp","PageDown","LeftShift","RightShift","LeftMeta","RightMeta","LeftAlt","RightAlt","LeftControl","RightControl","CapsLock","NumLock","ScrollLock","LeftSuper","RightSuper","Mode","Compose","Help","Print","SysReq","Break","Menu","Power","Euro","Undo","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","F13","F14","F15","World0","World1","World2","World3","World4","World5","World6","World7","World8","World9","World10","World11","World12","World13","World14","World15","World16","World17","World18","World19","World20","World21","World22","World23","World24","World25","World26","World27","World28","World29","World30","World31","World32","World33","World34","World35","World36","World37","World38","World39","World40","World41","World42","World43","World44","World45","World46","World47","World48","World49","World50","World51","World52","World53","World54","World55","World56","World57","World58","World59","World60","World61","World62","World63","World64","World65","World66","World67","World68","World69","World70","World71","World72","World73","World74","World75","World76","World77","World78","World79","World80","World81","World82","World83","World84","World85","World86","World87","World88","World89","World90","World91","World92","World93","World94","World95","ButtonX","ButtonY","ButtonA","ButtonB","ButtonR1","ButtonL1","ButtonR2","ButtonL2","ButtonR3","ButtonL3","ButtonStart","ButtonSelect","DPadLeft","DPadRight","DPadUp","DPadDown","Thumbstick1","Thumbstick2"}),KeywordFilterType=k({"Include","Exclude"}),Language=k({"Default"}),LeftRight=k({"Left","Center","Right"}),LevelOfDetailSetting=k({"High","Medium","Low"}),Limb=k({"Head","Torso","LeftArm","RightArm","LeftLeg","RightLeg","Unknown"}),ListDisplayMode=k({"Horizontal","Vertical"}),ListenerType=k({"Camera","CFrame","ObjectPosition","ObjectCFrame"}),Material=k({"Plastic","Wood","Slate","Concrete","CorrodedMetal","DiamondPlate","Foil","Grass","Ice","Marble","Granite","Brick","Pebble","Sand","Fabric","SmoothPlastic","Metal","WoodPlanks","Cobblestone","Air","Water","Rock","Glacier","Snow","Sandstone","Mud","Basalt","Ground","CrackedLava","Neon","Glass","Asphalt","LeafyGrass","Salt","Limestone","Pavement","ForceField"}),MembershipType=k({"None","BuildersClub","TurboBuildersClub","OutrageousBuildersClub"}),MeshType=k({"Head","Torso","Wedge","Prism","Pyramid","ParallelRamp","RightAngleRamp","CornerWedge","Brick","Sphere","Cylinder","FileMesh"}),MessageType=k({"MessageOutput","MessageInfo","MessageWarning","MessageError"}),MouseBehavior=k({"Default","LockCenter","LockCurrentPosition"}),MoveState=k({"Stopped","Coasting","Pushing","Stopping","AirFree"}),NameOcclusion=k({"OccludeAll","EnemyOcclusion","NoOcclusion"}),NetworkOwnership=k({"Automatic","Manual","OnContact"}),NormalId=k({"Top","Bottom","Back","Front","Right","Left"}),OutputLayoutMode=k({"Horizontal","Vertical"}),OverrideMouseIconBehavior=k({"None","ForceShow","ForceHide"}),PacketPriority=k({"IMMEDIATE_PRIORITY","HIGH_PRIORITY","MEDIUM_PRIORITY","LOW_PRIORITY"}),PartType=k({"Ball","Block","Cylinder"}),PathStatus=k({"Success","ClosestNoPath","ClosestOutOfRange","FailStartNotEmpty","FailFinishNotEmpty","NoPath"}),PathWaypointAction=k({"Walk","Jump"}),PermissionLevelShown=k({"Game","RobloxGame","RobloxScript","Studio","Roblox"}),Platform=k({"Windows","OSX","IOS","Android","XBoxOne","PS4","PS3","XBox360","WiiU","NX","Ouya","AndroidTV","Chromecast","Linux","SteamOS","WebOS","DOS","BeOS","UWP","None"}),PlaybackState=k({"Begin","Delayed","Playing","Paused","Completed","Cancelled"}),PlayerActions=k({"CharacterForward","CharacterBackward","CharacterLeft","CharacterRight","CharacterJump"}),PlayerChatType=k({"All","Team","Whisper"}),PoseEasingDirection=k({"Out","InOut","In"}),PoseEasingStyle=k({"Linear","Constant","Elastic","Cubic","Bounce"}),PrivilegeType=k({"Owner","Admin","Member","Visitor","Banned"}),ProductPurchaseDecision=k({"NotProcessedYet","PurchaseGranted"}),QualityLevel=k({"Automatic","Level01","Level02","Level03","Level04","Level05","Level06","Level07","Level08","Level09","Level10","Level11","Level12","Level13","Level14","Level15","Level16","Level17","Level18","Level19","Level20","Level21"}),R15CollisionType=k({"OuterBox","InnerBox"}),RenderFidelity=k({"Automatic","Precise"}),RenderPriority=k({"First","Input","Camera","Character","Last"}),RenderingTestComparisonMethod=k({"psnr","diff"}),ReverbType=k({"NoReverb","GenericReverb","PaddedCell","Room","Bathroom","LivingRoom","StoneRoom","Auditorium","ConcertHall","Cave","Arena","Hangar","CarpettedHallway","Hallway","StoneCorridor","Alley","Forest","City","Mountains","Quarry","Plain","ParkingLot","SewerPipe","UnderWater"}),RibbonTool=k({"Select","Scale","Rotate","Move","Transform","ColorPicker","MaterialPicker","Group","Ungroup","None"}),RollOffMode=k({"Inverse","Linear","InverseTapered","LinearSquare"}),RotationType=k({"MovementRelative","CameraRelative"}),RuntimeUndoBehavior=k({"Aggregate","Snapshot","Hybrid"}),SaveFilter=k({"SaveAll","SaveWorld","SaveGame"}),SavedQualitySetting=k({"Automatic","QualityLevel1","QualityLevel2","QualityLevel3","QualityLevel4","QualityLevel5","QualityLevel6","QualityLevel7","QualityLevel8","QualityLevel9","QualityLevel10"}),ScaleType=k({"Stretch","Slice","Tile","Fit","Crop"}),ScreenOrientation=k({"LandscapeLeft","LandscapeRight","LandscapeSensor","Portrait","Sensor"}),ScrollBarInset=k({"None","ScrollBar","Always"}),ScrollingDirection=k({"X","Y","XY"}),ServerAudioBehavior=k({"Enabled","Muted","OnlineGame"}),SizeConstraint=k({"RelativeXY","RelativeXX","RelativeYY"}),SortOrder=k({"LayoutOrder","Name","Custom"}),SoundType=k({"NoSound","Boing","Bomb","Break","Click","Clock","Slingshot","Page","Ping","Snap","Splat","Step","StepOn","Swoosh","Victory"}),SpecialKey=k({"Insert","Home","End","PageUp","PageDown","ChatHotkey"}),StartCorner=k({"TopLeft","TopRight","BottomLeft","BottomRight"}),Status=k({"Poison","Confusion"}),StudioStyleGuideColor=k({"MainBackground","Titlebar","Dropdown","Tooltip","Notification","ScrollBar","ScrollBarBackground","TabBar","Tab","RibbonTab","RibbonTabTopBar","Button","MainButton","RibbonButton","ViewPortBackground","InputFieldBackground","Item","TableItem","CategoryItem","GameSettingsTableItem","GameSettingsTooltip","EmulatorBar","EmulatorDropDown","ColorPickerFrame","CurrentMarker","Border","Shadow","Light","Dark","Mid","MainText","SubText","TitlebarText","BrightText","DimmedText","LinkText","WarningText","ErrorText","InfoText","SensitiveText","ScriptSideWidget","ScriptBackground","ScriptText","ScriptSelectionText","ScriptSelectionBackground","ScriptFindSelectionBackground","ScriptMatchingWordSelectionBackground","ScriptOperator","ScriptNumber","ScriptString","ScriptComment","ScriptPreprocessor","ScriptKeyword","ScriptBuiltInFunction","ScriptWarning","ScriptError","DebuggerCurrentLine","DebuggerErrorLine","DiffFilePathText","DiffTextHunkInfo","DiffTextNoChange","DiffTextAddition","DiffTextDeletion","DiffTextSeparatorBackground","DiffTextNoChangeBackground","DiffTextAdditionBackground","DiffTextDeletionBackground","DiffLineNum","DiffLineNumSeparatorBackground","DiffLineNumNoChangeBackground","DiffLineNumAdditionBackground","DiffLineNumDeletionBackground","DiffFilePathBackground","DiffFilePathBorder","Separator","ButtonBorder","ButtonText","InputFieldBorder","CheckedFieldBackground","CheckedFieldBorder","CheckedFieldIndicator","HeaderSection","Midlight","StatusBar"}),StudioStyleGuideModifier=k({"Default","Selected","Pressed","Disabled","Hover"}),Style=k({"AlternatingSupports","BridgeStyleSupports","NoSupports"}),SurfaceConstraint=k({"None","Hinge","SteppingMotor","Motor"}),SurfaceType=k({"Smooth","Glue","Weld","Studs","Inlet","Universal","Hinge","Motor","SteppingMotor","SmoothNoOutlines"}),SwipeDirection=k({"Right","Left","Up","Down","None"}),TableMajorAxis=k({"RowMajor","ColumnMajor"}),Technology=k({"Legacy","Voxel","Compatibility"}),TeleportResult=k({"Success","Failure","GameNotFound","GameEnded","GameFull","Unauthorized","Flooded","IsTeleporting"}),TeleportState=k({"RequestedFromServer","Started","WaitingForServer","Failed","InProgress"}),TeleportType=k({"ToPlace","ToInstance","ToReservedServer"}),TextFilterContext=k({"PublicChat","PrivateChat"}),TextTruncate=k({"None","AtEnd"}),TextXAlignment=k({"Left","Center","Right"}),TextYAlignment=k({"Top","Center","Bottom"}),TextureMode=k({"Stretch","Wrap","Static"}),TextureQueryType=k({"NonHumanoid","NonHumanoidOrphaned","Humanoid","HumanoidOrphaned"}),ThreadPoolConfig=k({"Auto","PerCore1","PerCore2","PerCore3","PerCore4","Threads1","Threads2","Threads3","Threads4","Threads8","Threads16"}),ThrottlingPriority=k({"Extreme","ElevatedOnServer","Default"}),ThumbnailSize=k({"Size48x48","Size180x180","Size420x420","Size60x60","Size100x100","Size150x150","Size352x352"}),ThumbnailType=k({"HeadShot","AvatarBust","AvatarThumbnail"}),TickCountSampleMethod=k({"Fast","Benchmark","Precise"}),TopBottom=k({"Top","Center","Bottom"}),TouchCameraMovementMode=k({"Default","Follow","Classic","Orbital"}),TouchMovementMode=k({"Default","Thumbstick","DPad","Thumbpad","ClickToMove","DynamicThumbstick"}),TweenStatus=k({"Canceled","Completed"}),UITheme=k({"Light","Dark"}),UiMessageType=k({"UiMessageError","UiMessageInfo"}),UploadSetting=k({"Never","Ask","Always"}),UserCFrame=k({"Head","LeftHand","RightHand"}),UserInputState=k({"Begin","Change","End","Cancel","None"}),UserInputType=k({"MouseButton1","MouseButton2","MouseButton3","MouseWheel","MouseMovement","Touch","Keyboard","Focus","Accelerometer","Gyro","Gamepad1","Gamepad2","Gamepad3","Gamepad4","Gamepad5","Gamepad6","Gamepad7","Gamepad8","TextInput","InputMethod","None"}),VRTouchpad=k({"Left","Right"}),VRTouchpadMode=k({"Touch","VirtualThumbstick","ABXY"}),VerticalAlignment=k({"Center","Top","Bottom"}),VerticalScrollBarPosition=k({"Left","Right"}),VibrationMotor=k({"Large","Small","LeftTrigger","RightTrigger","LeftHand","RightHand"}),VideoQualitySettings=k({"LowResolution","MediumResolution","HighResolution"}),VirtualInputMode=k({"Recording","Playing","None"}),WaterDirection=k({"NegX","X","NegY","Y","NegZ","Z"}),WaterForce=k({"None","Small","Medium","Strong","Max"}),ZIndexBehavior=k({"Global","Sibling"})}}}}stds.testez={read_globals={"describe","it","itFOCUS","itSKIP","FOCUS","SKIP","HACK_NO_XPCALL","expect"}}stds.plugin={read_globals={"plugin","DebuggerManager"}}ignore={}std="lua51+roblox"files["**/*.spec.lua"]={std="+testez"}

