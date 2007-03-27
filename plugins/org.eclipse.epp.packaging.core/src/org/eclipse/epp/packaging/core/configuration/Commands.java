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

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * Configurable default implementation of ICommands.
 */
public class Commands implements ICommands {

  private File file;
  private Task[] tasks = Task.values();

  public File getConfigurationFile() {
    return file;
  }

  public void setConfigurationFile( final String fileName ) {
    this.file = new File( fileName );
  }

  public boolean mustDo( final Task task ) {
    boolean result = false;
    for( Task configuredTask : tasks ) {
      result |= configuredTask.equals( task );
    }
    return result;
  }

  public void setTasks( final String[] tasks ) {
    List<Task> taskList = new ArrayList<Task>();
    for( String task : tasks ) {
      taskList.add( Task.valueOf( task.toUpperCase() ) );
    }
    this.tasks = taskList.toArray( new Task[ taskList.size() ] );
  }
}