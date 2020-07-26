<!--
Copyright (c) 2010, 2015 Mia-Software and others.
All rights reserved. This program and the accompanying materials
are made available under the terms of the Eclipse Public License v2.0
which accompanies this distribution, and is available at
http://www.eclipse.org/legal/epl-v20.html

Contributors:
  Gregoire Dupe (initial version)
  Markus Knauer (ongoing maintenance)

-->
<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform' version="1.0">
  <xsl:output encoding="UTF-8" method="xml" indent="yes" />
  <xsl:strip-space elements="*" />

  <xsl:template match="/">
    <xsl:processing-instruction name="artifactRepository">version='1.1.0'</xsl:processing-instruction>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="repository/properties">
    <properties size='{@size+1}'>
      <xsl:copy-of select="property" />
      <property name='p2.statsURI' value='http://download.eclipse.org/stats/technology/epp/packages/2020-03' />
    </properties>
  </xsl:template>

  <xsl:template match="artifact[@classifier='osgi.bundle' and @id='org.eclipse.epp.package.committers']/properties">
    <xsl:call-template name="artifact_properties" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='osgi.bundle' and @id='org.eclipse.epp.package.cpp']/properties">
    <xsl:call-template name="artifact_properties" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='osgi.bundle' and @id='org.eclipse.epp.package.embedcdt']/properties">
    <xsl:call-template name="artifact_properties" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='osgi.bundle' and @id='org.eclipse.epp.package.dsl']/properties">
    <xsl:call-template name="artifact_properties" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='osgi.bundle' and @id='org.eclipse.epp.package.java']/properties">
    <xsl:call-template name="artifact_properties" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='osgi.bundle' and @id='org.eclipse.epp.package.javascript']/properties">
    <xsl:call-template name="artifact_properties" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='osgi.bundle' and @id='org.eclipse.epp.package.jee']/properties">
    <xsl:call-template name="artifact_properties" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='osgi.bundle' and @id='org.eclipse.epp.package.modeling']/properties">
    <xsl:call-template name="artifact_properties" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='osgi.bundle' and @id='org.eclipse.epp.package.parallel']/properties">
    <xsl:call-template name="artifact_properties" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='osgi.bundle' and @id='org.eclipse.epp.package.php']/properties">
    <xsl:call-template name="artifact_properties" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='osgi.bundle' and @id='org.eclipse.epp.package.rcp']/properties">
    <xsl:call-template name="artifact_properties" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='osgi.bundle' and @id='org.eclipse.epp.package.scout']/properties">
    <xsl:call-template name="artifact_properties" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='osgi.bundle' and @id='org.eclipse.epp.package.testing']/properties">
    <xsl:call-template name="artifact_properties" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='osgi.bundle' and @id='org.eclipse.epp.package.rust']/properties">
    <xsl:call-template name="artifact_properties" />
  </xsl:template>

  <xsl:template name="artifact_properties">
    <properties size='{@size+1}'>
      <xsl:copy-of select="property" />
      <property name='download.stats' value='{../@id}.bundle-{../@version}' />
    </properties>
  </xsl:template>


  <xsl:template match="artifact[@classifier='org.eclipse.update.feature' and @id='org.eclipse.epp.package.committers.feature']/properties">
    <xsl:call-template name="artifact_properties_feature" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='org.eclipse.update.feature' and @id='org.eclipse.epp.package.common.feature']/properties">
    <xsl:call-template name="artifact_properties_feature" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='org.eclipse.update.feature' and @id='org.eclipse.epp.package.cpp.feature']/properties">
    <xsl:call-template name="artifact_properties_feature" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='org.eclipse.update.feature' and @id='org.eclipse.epp.package.embedcdt.feature']/properties">
    <xsl:call-template name="artifact_properties_feature" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='org.eclipse.update.feature' and @id='org.eclipse.epp.package.dsl.feature']/properties">
    <xsl:call-template name="artifact_properties_feature" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='org.eclipse.update.feature' and @id='org.eclipse.epp.package.java.feature']/properties">
    <xsl:call-template name="artifact_properties_feature" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='org.eclipse.update.feature' and @id='org.eclipse.epp.package.javascript.feature']/properties">
    <xsl:call-template name="artifact_properties_feature" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='org.eclipse.update.feature' and @id='org.eclipse.epp.package.jee.feature']/properties">
    <xsl:call-template name="artifact_properties_feature" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='org.eclipse.update.feature' and @id='org.eclipse.epp.package.modeling.feature']/properties">
    <xsl:call-template name="artifact_properties_feature" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='org.eclipse.update.feature' and @id='org.eclipse.epp.package.parallel.feature']/properties">
    <xsl:call-template name="artifact_properties_feature" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='org.eclipse.update.feature' and @id='org.eclipse.epp.package.php.feature']/properties">
    <xsl:call-template name="artifact_properties_feature" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='org.eclipse.update.feature' and @id='org.eclipse.epp.package.rcp.feature']/properties">
    <xsl:call-template name="artifact_properties_feature" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='org.eclipse.update.feature' and @id='org.eclipse.epp.package.scout.feature']/properties">
    <xsl:call-template name="artifact_properties_feature" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='org.eclipse.update.feature' and @id='org.eclipse.epp.package.testing.feature']/properties">
    <xsl:call-template name="artifact_properties_feature" />
  </xsl:template>

  <xsl:template match="artifact[@classifier='org.eclipse.update.feature' and @id='org.eclipse.epp.package.rust.feature']/properties">
    <xsl:call-template name="artifact_properties_feature" />
  </xsl:template>

  <xsl:template name="artifact_properties_feature">
    <properties size='{@size+1}'>
      <xsl:copy-of select="property" />
      <property name='download.stats' value='{../@id}-{../@version}' />
    </properties>
  </xsl:template>

  <xsl:template match="*">
    <xsl:copy>
      <xsl:for-each select="@*">
        <xsl:copy-of select="." />
      </xsl:for-each>
      <xsl:apply-templates />
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
