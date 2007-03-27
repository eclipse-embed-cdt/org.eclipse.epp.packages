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

/**
 * Represents a platform configuration, consisting of operating system (os),
 * window system (ws) and system architecture (arch).
 */
public interface IPlatform {

  public ArchiveFormat getArchiveFormat();

  /**
   * Returns the platform components separated by the separator. Example:
   * toString(".") for linux,gtk,x86 return "linux.gtk.x86".
   * 
   * @param separator A separator character
   * @return The platform description formatted as
   *         [OS][separator][WS][separator][Arch]
   */
  public String toString( char separator );

  /**
   * Builds the file name of the platform files for this platform, using the
   * base name provided in configuration.
   */
  public String getRootFileName( IPackagerConfiguration configuration );

  /** Configures the SiteManager to use platform as its current one. */
  public void configureSite();

  /**
   * Builds and returns the filename of the target archive for this platform,
   * using the base name provided in configuration.
   */
  public String getTargetFileName( IPackagerConfiguration configuration );

  /** Returns the name installer-creating script most suitable for this platform. */
  public String getInstallScriptName();
}
