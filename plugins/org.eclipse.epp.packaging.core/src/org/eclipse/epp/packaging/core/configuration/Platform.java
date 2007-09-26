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
package org.eclipse.epp.packaging.core.configuration;

import static org.eclipse.core.runtime.Platform.ARCH_X86;
import static org.eclipse.core.runtime.Platform.ARCH_X86_64;
import static org.eclipse.core.runtime.Platform.OS_LINUX;
import static org.eclipse.core.runtime.Platform.OS_WIN32;
import static org.eclipse.core.runtime.Platform.WS_GTK;
import org.eclipse.update.core.SiteManager;

/**
 * Represents a platform configuration, consisting of operating system (os),
 * windowing system (ws) and system architecture (arch). Default implementation
 * of IPlatform.
 */
public class Platform implements IPlatform {

  private final String os;
  private final String ws;
  private final String arch;
  private final String eclipseIniFileContent;
  private ArchiveFormat archiveFormat = ArchiveFormat.antZip;

  public Platform( final String os,
                   final String ws,
                   final String arch,
                   final String eclipseIniFileContent )
  {
    this.os = os;
    this.ws = ws;
    this.arch = arch;
    this.eclipseIniFileContent = eclipseIniFileContent;
  }

  @Override
  public boolean equals( final Object obj ) {
    boolean result = false;
    if( obj instanceof Platform ) {
      Platform other = ( Platform )obj;
      result = os.equals( other.os )
               && ws.equals( other.ws )
               && arch.equals( other.arch );
    }
    return result;
  }

  public String toString( final char separator ) {
    return os + separator + ws + separator + arch;
  }

  /** Identical with toString(',) */
  @Override
  public String toString() {
    return toString( ',' );
  }

  public ArchiveFormat getArchiveFormat() {
    return archiveFormat;
  }

  public void setArchiveFormat( final String format ) {
    this.archiveFormat = ArchiveFormat.valueOf( format );
  }

  public void configureSite() {
    SiteManager.setOS( os );
    SiteManager.setWS( ws );
    SiteManager.setOSArch( arch );
  }

  // Requires PDE Build with up-to-date unzippergenerator.
  public String getRootFileName( final IPackagerConfiguration configuration ) {
    StringBuilder builder = new StringBuilder( configuration.getRootFileBaseName() );
    builder.append( os );
    boolean isWin32 = isWin32();
    if( !isWin32 ) {
      builder.append( '-' );
      builder.append( ws );
    }
    boolean isLinuxGtk = isLinux() && WS_GTK.endsWith( ws );
    if( ( isWin32 || isLinuxGtk ) && !isX86() ) {
      builder.append( '-' );
      builder.append( arch );
    }
    builder.append( archiveFormat.getExtension() );
    return builder.toString();
  }

  private boolean isLinux() {
    return OS_LINUX.equals( os );
  }

  private boolean isX86() {
    return ARCH_X86.equals( arch );
  }

  private boolean isWin32() {
    return OS_WIN32.equals( os );
  }

  public String getTargetFileName( final IPackagerConfiguration configuration )
  {
    return configuration.getProductName() + "-" //$NON-NLS-1$
           + toString( '.' );
  }

  public String getInstallScriptName() {
    String buildFile;
    boolean isWin32x86 = isWin32() && isX86();
    boolean isLinuxX86 = isLinux() && ( isX86() || ARCH_X86_64.equals( arch ) );
    if( ( isWin32x86 || isLinuxX86 ) ) {
      buildFile = "build-installer-" + os + ".xml"; //$NON-NLS-1$ //$NON-NLS-2$
    } else {
      buildFile = "build-installer-default.xml"; //$NON-NLS-1$
    }
    return buildFile;
  }

  public String getEclipseIniFileContent() {
    return eclipseIniFileContent;
  }
}