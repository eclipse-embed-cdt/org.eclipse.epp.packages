/*******************************************************************************
 * Copyright (c) 2007 Innoopract Informationssysteme GmbH
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *    Innoopract - initial API and implementation
 *******************************************************************************/
package org.eclipse.epp.packaging.core.assembly;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;

import org.eclipse.epp.packaging.core.configuration.IPackagerConfiguration;
import org.eclipse.epp.packaging.core.configuration.IPlatform;
import org.eclipse.epp.packaging.core.io.FileUtils;

/**
 * Completes the custom targets stub to form a customtargets.xml ant file.
 * The targets added define the output files for each platform.
 */
public class CustomTargetsWriter {

  private final PrintWriter writer;
  private final IPackagerConfiguration configuration;

  /**
   * TODO mknauer missing doc
   * @param configuration
   * @param baseFile
   * @throws IOException
   */
  public CustomTargetsWriter( final IPackagerConfiguration configuration,
                              final String baseFile ) throws IOException
  {
    this.configuration = configuration;
    File stubFile = new File( configuration.getPackagerConfigurationFolder(),
                              baseFile );
    File customTargetsFile = new File( configuration.getPackagerConfigurationFolder(),
                                       "customTargets.xml" ); //$NON-NLS-1$
    FileUtils.copy( stubFile, customTargetsFile );
    FileOutputStream stream = new FileOutputStream( customTargetsFile, true );
    this.writer = new PrintWriter( stream );
  }

  /**
   * TODO mknauer missing doc
   * @param platform
   */
  public void addTargetFileForPlatform( final IPlatform platform ) {
    this.writer.append( "  <target name=\"assemble." //$NON-NLS-1$
                        + platform.toString( '.' )
                        + ".xml\" depends=\"init\">\n" ); //$NON-NLS-1$
    
    this.writer.append( "    <replaceregexp file=\"${tempDirectory}/"  //$NON-NLS-1$
                        + platform.toString( '.' ) 
                        + "/eclipse/configuration/config.ini\"\n" ); //$NON-NLS-1$
    this.writer.append( "      match=\"eclipse.product=(.*)\"\n" ); //$NON-NLS-1$
    this.writer.append( "      replace=\"eclipse.product="  //$NON-NLS-1$
                        + this.configuration.getEclipseProductId() 
                        + "\"\n" ); //$NON-NLS-1$
    this.writer.append( "      byline=\"true\" />\n" ); //$NON-NLS-1$
    
    this.writer.append( "    <replaceregexp byline=\"true\">\n" ); //$NON-NLS-1$
    this.writer.append( "      <regexp pattern=\"org.eclipse.ui/defaultPerspectiveId=(.*)\"/>\n" ); //$NON-NLS-1$
    this.writer.append( "      <substitution expression=\"org.eclipse.ui/defaultPerspectiveId="  //$NON-NLS-1$
                        + this.configuration.getInitialPerspectiveId() 
                        + "\"/>\n" ); //$NON-NLS-1$
    this.writer.append( "      <fileset dir=\"${tempDirectory}/eclipse/plugins/\" includes=\""  //$NON-NLS-1$
//                        + this.configuration.getEclipseProductId()
                        + "*/plugin_customization.ini\"/>\n" ); //$NON-NLS-1$
    this.writer.append( "    </replaceregexp>\n" ); //$NON-NLS-1$
    
    this.writer.append( "    <echo file=\"${tempDirectory}/"  //$NON-NLS-1$
                        + platform.toString( '.' )  
                        + platform.getEclipseIniFilePath()
                        + "eclipse.ini\">" ); //$NON-NLS-1$
    this.writer.append( platform.getEclipseIniFileContent() );
    this.writer.append( "    </echo>\n" ); //$NON-NLS-1$
    
    this.writer.append( "    <ant antfile=\"${assembleScriptName}\" >\n" ); //$NON-NLS-1$
    this.writer.append( "    <property name=\"archiveName\" value=\"" //$NON-NLS-1$
                        + platform.getTargetFileName( this.configuration )
                        + platform.getArchiveFormat().getExtension()
                        + "\"/>\n" ); //$NON-NLS-1$
    this.writer.append( "    </ant>\n" ); //$NON-NLS-1$
    this.writer.append( "  </target>\n" ); //$NON-NLS-1$
  }

  /**
   * TODO mknauer missing doc
   */
  public void close() {
    this.writer.append( "</project>\n" ); //$NON-NLS-1$
    this.writer.close();
  }
}
