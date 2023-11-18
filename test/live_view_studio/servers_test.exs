defmodule LiveViewStudio.ServersTest do
  use LiveViewStudio.DataCase

  alias LiveViewStudio.Servers

  describe "servers" do
    alias LiveViewStudio.Servers.Server

    import LiveViewStudio.ServersFixtures

    @invalid_attrs %{name: nil, size: nil, status: nil, deploy_count: nil, framework: nil, git_repo: nil, last_commit_id: nil, last_commit_message: nil}

    test "list_servers/0 returns all servers" do
      server = server_fixture()
      assert Servers.list_servers() == [server]
    end

    test "get_server!/1 returns the server with given id" do
      server = server_fixture()
      assert Servers.get_server!(server.id) == server
    end

    test "create_server/1 with valid data creates a server" do
      valid_attrs = %{name: "some name", size: 120.5, status: "some status", deploy_count: 42, framework: "some framework", git_repo: "some git_repo", last_commit_id: "some last_commit_id", last_commit_message: "some last_commit_message"}

      assert {:ok, %Server{} = server} = Servers.create_server(valid_attrs)
      assert server.name == "some name"
      assert server.size == 120.5
      assert server.status == "some status"
      assert server.deploy_count == 42
      assert server.framework == "some framework"
      assert server.git_repo == "some git_repo"
      assert server.last_commit_id == "some last_commit_id"
      assert server.last_commit_message == "some last_commit_message"
    end

    test "create_server/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Servers.create_server(@invalid_attrs)
    end

    test "update_server/2 with valid data updates the server" do
      server = server_fixture()
      update_attrs = %{name: "some updated name", size: 456.7, status: "some updated status", deploy_count: 43, framework: "some updated framework", git_repo: "some updated git_repo", last_commit_id: "some updated last_commit_id", last_commit_message: "some updated last_commit_message"}

      assert {:ok, %Server{} = server} = Servers.update_server(server, update_attrs)
      assert server.name == "some updated name"
      assert server.size == 456.7
      assert server.status == "some updated status"
      assert server.deploy_count == 43
      assert server.framework == "some updated framework"
      assert server.git_repo == "some updated git_repo"
      assert server.last_commit_id == "some updated last_commit_id"
      assert server.last_commit_message == "some updated last_commit_message"
    end

    test "update_server/2 with invalid data returns error changeset" do
      server = server_fixture()
      assert {:error, %Ecto.Changeset{}} = Servers.update_server(server, @invalid_attrs)
      assert server == Servers.get_server!(server.id)
    end

    test "delete_server/1 deletes the server" do
      server = server_fixture()
      assert {:ok, %Server{}} = Servers.delete_server(server)
      assert_raise Ecto.NoResultsError, fn -> Servers.get_server!(server.id) end
    end

    test "change_server/1 returns a server changeset" do
      server = server_fixture()
      assert %Ecto.Changeset{} = Servers.change_server(server)
    end
  end
end
