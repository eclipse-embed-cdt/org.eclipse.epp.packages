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

import org.eclipse.epp.packaging.core.configuration.Platform;

import junit.framework.Assert;
import junit.framework.TestCase;

/**Test class */
public class Platform_Test extends TestCase {

  public void testEquals() throws Exception {
    Platform platform = new Platform( "win32", "win32", "x86", null, null ); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
    Platform secondPlatform = new Platform( "win32", "win32", "x86", null, null ); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
    assertTrue( platform.equals( secondPlatform ) );
  }

  public void testToString() throws Exception {
    Platform platform = new Platform( "win32", "win32", "x86", null, null ); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
    Assert.assertEquals( "win32,win32,x86", platform.toString() ); //$NON-NLS-1$
  }

  public void testAdvancedToString() throws Exception {
    Platform platform = new Platform( "win32", "win32", "x86", null, null ); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
    Assert.assertEquals( "win32nwin32nx86", platform.toString( 'n' ) ); //$NON-NLS-1$
  }

  public void testDefaultArchiveFormat() {
    Platform platform = new Platform( "win32", "win32", "x86", null, null ); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
    Assert.assertEquals( "antZip", platform.getArchiveFormat().name() ); //$NON-NLS-1$
  }

  public void testSetArchiveFormat() throws Exception {
    Platform platform = new Platform( "win32", "win32", "x86", null, null ); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
    platform.setArchiveFormat( "tar" ); //$NON-NLS-1$
    Assert.assertEquals( "tar", platform.getArchiveFormat().name() ); //$NON-NLS-1$
  }
}