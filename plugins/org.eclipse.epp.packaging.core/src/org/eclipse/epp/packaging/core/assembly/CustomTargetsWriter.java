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
    this.writer.append( "<target name=\"assemble." //$NON-NLS-1$
                        + platform.toString( '.' )
                        + ".xml\" depends=\"init\">\n" ); //$NON-NLS-1$
    this.writer.append( "<ant antfile=\"${assembleScriptName}\" >\n" ); //$NON-NLS-1$
    this.writer.append( "<property name=\"archiveName\" value=\"" //$NON-NLS-1$
                        + platform.getTargetFileName( this.configuration )
                        + platform.getArchiveFormat().getExtension()
                        + "\"/>\n" ); //$NON-NLS-1$
    this.writer.append( "</ant>\n" ); //$NON-NLS-1$
    this.writer.append( "</target>\n" ); //$NON-NLS-1$
  }

  /**
   * TODO mknauer missing doc
   */
  public void close() {
    this.writer.append( "</project>\n" ); //$NON-NLS-1$
    this.writer.close();
  }
}
