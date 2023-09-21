<map version="freeplane 1.11.5">
<!--To view this file, download free mind mapping software Freeplane from https://www.freeplane.org -->
<node TEXT="Shaders for scientific visualisation" FOLDED="false" ID="1" CREATED="1695037865331" MODIFIED="1695037886479"><hook NAME="MapStyle" zoom="0.77">
    <properties edgeColorConfiguration="#808080ff,#ff0000ff,#0000ffff,#00ff00ff,#ff00ffff,#00ffffff,#7c0000ff,#00007cff,#007c00ff,#7c007cff,#007c7cff,#7c7c00ff" fit_to_viewport="false" show_icon_for_attributes="true" show_note_icons="true"/>

<map_styles>
<stylenode LOCALIZED_TEXT="styles.root_node" STYLE="oval" UNIFORM_SHAPE="true" VGAP_QUANTITY="24 pt">
<font SIZE="24"/>
<stylenode LOCALIZED_TEXT="styles.predefined" POSITION="bottom_or_right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="default" ID="ID_271890427" ICON_SIZE="12 pt" COLOR="#000000" STYLE="fork">
<arrowlink SHAPE="CUBIC_CURVE" COLOR="#000000" WIDTH="2" TRANSPARENCY="200" DASH="" FONT_SIZE="9" FONT_FAMILY="SansSerif" DESTINATION="ID_271890427" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<font NAME="SansSerif" SIZE="10" BOLD="false" ITALIC="false"/>
<richcontent TYPE="DETAILS" CONTENT-TYPE="plain/auto"/>
<richcontent TYPE="NOTE" CONTENT-TYPE="plain/auto"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.details"/>
<stylenode LOCALIZED_TEXT="defaultstyle.attributes">
<font SIZE="9"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.note" COLOR="#000000" BACKGROUND_COLOR="#ffffff" TEXT_ALIGN="LEFT"/>
<stylenode LOCALIZED_TEXT="defaultstyle.floating">
<edge STYLE="hide_edge"/>
<cloud COLOR="#f0f0f0" SHAPE="ROUND_RECT"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.selection" BACKGROUND_COLOR="#afd3f7" BORDER_COLOR_LIKE_EDGE="false" BORDER_COLOR="#afd3f7"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.user-defined" POSITION="bottom_or_right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="styles.topic" COLOR="#18898b" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subtopic" COLOR="#cc3300" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subsubtopic" COLOR="#669900">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.important" ID="ID_67550811">
<icon BUILTIN="yes"/>
<arrowlink COLOR="#003399" TRANSPARENCY="255" DESTINATION="ID_67550811"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.AutomaticLayout" POSITION="bottom_or_right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="AutomaticLayout.level.root" COLOR="#000000" STYLE="oval" SHAPE_HORIZONTAL_MARGIN="10 pt" SHAPE_VERTICAL_MARGIN="10 pt">
<font SIZE="18"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,1" COLOR="#0033ff">
<font SIZE="16"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,2" COLOR="#00b439">
<font SIZE="14"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,3" COLOR="#990000">
<font SIZE="12"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,4" COLOR="#111111">
<font SIZE="10"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,5"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,6"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,7"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,8"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,9"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,10"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,11"/>
</stylenode>
</stylenode>
</map_styles>
</hook>
<node TEXT="Jupyter Support" ID="2" CREATED="1695037865331" MODIFIED="1695037865331">
<node TEXT="WebGL" ID="59" CREATED="1695037865331" MODIFIED="1695037865331">
<node TEXT="Would need to find a library that offers bindings" ID="64" CREATED="1695037865331" MODIFIED="1695037865331"/>
<node TEXT="WebGL2 probably offers all the features we need" ID="65" CREATED="1695037865331" MODIFIED="1695037865331"/>
<node TEXT="For use-cases such as in Google Collab, this would mean that the entire dataset to be rendered would need to be downloaded to the client. SSR avoids this but has the overhead of streaming rendered frames" ID="66" CREATED="1695037865331" MODIFIED="1695037865331"/>
</node>
<node TEXT=" OpenGL" ID="60" CREATED="1695037865331" MODIFIED="1695037865331">
<node TEXT="SSR + H264/PNG streaming" ID="61" CREATED="1695037865331" MODIFIED="1695037865331"/>
<node TEXT="Can use Glumpy" ID="62" CREATED="1695037865331" MODIFIED="1695037865331"/>
</node>
<node TEXT="GLSL syntax highlighting support" ID="68" CREATED="1695037865331" MODIFIED="1695037865331"/>
<node TEXT="Interactive plots support" ID="69" CREATED="1695037865331" MODIFIED="1695037865331"/>
<node TEXT="VSCode/PyCharm support " ID="70" CREATED="1695037865331" MODIFIED="1695037865331"/>
</node>
<node TEXT="Types of visualisation" ID="3" CREATED="1695037865331" MODIFIED="1695037865331">
<node TEXT="SDF rendering" ID="44" CREATED="1695037865331" MODIFIED="1695037865331">
<node TEXT="Solid, surface" ID="45" CREATED="1695037865331" MODIFIED="1695037865331"/>
<node TEXT="XRay/Volumetric" ID="46" CREATED="1695037865331" MODIFIED="1695037865331"/>
<node TEXT="Contour lines" ID="47" CREATED="1695037865331" MODIFIED="1695037865331"/>
</node>
<node TEXT="Correlation maps" ID="49" CREATED="1695037865332" MODIFIED="1695037865332"/>
<node TEXT="Animation over time" ID="50" CREATED="1695037865332" MODIFIED="1695037865332"/>
<node TEXT="Interaction with mouse/keyboard" ID="51" CREATED="1695037865332" MODIFIED="1695037865332"/>
<node TEXT="Point clouds" ID="56" CREATED="1695037865332" MODIFIED="1695037865332">
<node TEXT="&gt;1mil points" ID="57" CREATED="1695037865332" MODIFIED="1695037865332"/>
</node>
</node>
<node TEXT="UX" ID="4" CREATED="1695037865332" MODIFIED="1695037865332">
<node TEXT="Node based visualisation builder (Unity ShaderGraph?)" ID="9" CREATED="1695037865332" MODIFIED="1695037865332"/>
<node TEXT="GLSL shaders" ID="10" CREATED="1695037865332" MODIFIED="1695037865332">
<node TEXT="Raw GLSL" ID="11" CREATED="1695037865332" MODIFIED="1695037865332"/>
<node TEXT="Simple preprocessor language for metadata and linking (eg Unity ShaderLab)" ID="12" CREATED="1695037865332" MODIFIED="1695037865332">
<node TEXT="Could utilise the component library for code generation for certain types of visualisation" ID="39" CREATED="1695037865332" MODIFIED="1695037865332">
<node TEXT="(Along the lines of Unity Surface Shaders, but possibly for other types of rendering such as SDFs)" ID="40" CREATED="1695037865332" MODIFIED="1695037865332"/>
</node>
</node>
<node TEXT="Component library of commonly used data visualisation functions" ID="21" CREATED="1695037865332" MODIFIED="1695037865332">
<node TEXT="Colourmaps" ID="22" CREATED="1695037865332" MODIFIED="1695037865332"/>
<node TEXT="SDFs" ID="23" CREATED="1695037865332" MODIFIED="1695037865332"/>
<node TEXT="SDF renderers" ID="24" CREATED="1695037865332" MODIFIED="1695037865332">
<node TEXT="Solid" ID="25" CREATED="1695037865332" MODIFIED="1695037865332"/>
<node TEXT="XRay" ID="26" CREATED="1695037865332" MODIFIED="1695037865332"/>
<node TEXT="Contour lines" ID="27" CREATED="1695037865332" MODIFIED="1695037865332"/>
</node>
<node TEXT="Anti-aliased drawing" ID="30" CREATED="1695037865332" MODIFIED="1695037865332">
<node TEXT="Point clouds" ID="36" CREATED="1695037865333" MODIFIED="1695037865333"/>
<node TEXT="Lines" ID="37" CREATED="1695037865333" MODIFIED="1695037865333"/>
<node TEXT="Surfaces" ID="38" CREATED="1695037865334" MODIFIED="1695037865334"/>
</node>
<node TEXT="Basic text" ID="31" CREATED="1695037865334" MODIFIED="1695037865334"/>
<node TEXT="Analysis" ID="32" CREATED="1695037865334" MODIFIED="1695037865334">
<node TEXT="Finite difference based derivatives" ID="33" CREATED="1695037865334" MODIFIED="1695037865334"/>
<node TEXT="Transformations" ID="34" CREATED="1695037865334" MODIFIED="1695037865334"/>
</node>
<node TEXT="Mouse/keyboard interaction" ID="52" CREATED="1695037865334" MODIFIED="1695037865334">
<node TEXT="Ray picking" ID="53" CREATED="1695037865334" MODIFIED="1695037865334"/>
<node TEXT="Interactive timeline" ID="54" CREATED="1695037865334" MODIFIED="1695037865334"/>
<node TEXT="Slicing" ID="55" CREATED="1695037865334" MODIFIED="1695037865334"/>
</node>
</node>
<node TEXT="Vertex shaders" ID="42" CREATED="1695037865334" MODIFIED="1695037865334"/>
<node TEXT="Geometry shaders?" ID="43" CREATED="1695037865334" MODIFIED="1695037865334"/>
</node>
<node TEXT="Data input" ID="14" CREATED="1695037865334" MODIFIED="1695037865334">
<node TEXT="Pandas data frames" ID="15" CREATED="1695037865334" MODIFIED="1695037865334"/>
<node TEXT="Numpy array" ID="16" CREATED="1695037865334" MODIFIED="1695037865334"/>
<node TEXT="SDF functions (GLSL)?" ID="17" CREATED="1695037865334" MODIFIED="1695037865334"/>
<node TEXT="Textures (2D, 3D)" ID="18" CREATED="1695037865334" MODIFIED="1695037865334">
<node TEXT="From files" ID="19" CREATED="1695037865334" MODIFIED="1695037865334"/>
<node TEXT="From OpenGL resources" ID="20" CREATED="1695037865334" MODIFIED="1695037865334"/>
</node>
</node>
</node>
<node TEXT="Native Rendering" ID="5" CREATED="1695037865334" MODIFIED="1695037865334">
<node TEXT="Server-side rendering with OpenGL" ID="6" CREATED="1695037865334" MODIFIED="1695037865334"/>
<node TEXT="Streaming to Jupyter with H264" ID="7" CREATED="1695037865334" MODIFIED="1695037865334">
<node TEXT="Talk to Netallied?" ID="8" CREATED="1695037865334" MODIFIED="1695037865334"/>
</node>
</node>
</node>
</map>
