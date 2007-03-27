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

import java.io.IOException;

import org.eclipse.core.runtime.CoreException;

/**
 * Implementors know how to package an RCP Application.
 */
public interface IPackager {

  /**
   * Begins the packing process.
   * TODO mknauer missing doc
   * @throws CoreException 
   * @throws IOException 
   */
  public void packApplication() throws CoreException, IOException;
}