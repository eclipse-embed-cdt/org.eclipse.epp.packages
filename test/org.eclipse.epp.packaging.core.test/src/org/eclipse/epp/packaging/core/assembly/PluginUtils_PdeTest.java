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

import junit.framework.Assert;
import junit.framework.TestCase;

/** Test class*/
public class PluginUtils_PdeTest extends TestCase {

  public void testFindRuntimeCore() throws Exception {
    String pluginPath = PluginUtils.getPluginPath( "org.eclipse.core.runtime" ); //$NON-NLS-1$
    Assert.assertNotNull( pluginPath );
    Assert.assertTrue( new File( pluginPath ).exists() );
  }
}