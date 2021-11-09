function run_powermodels_pf(json_path)
    _PM.silence()
    pm = load_pm_from_json(json_path)
    model = get_model(pm["pm_model"])

    solver = get_solver(
        pm["pm_solver"],
        pm["pm_nl_solver"],
        pm["pm_mip_solver"],
        pm["pm_log_level"],
        pm["pm_time_limit"],
        pm["pm_nl_time_limit"],
        pm["pm_mip_time_limit"],
    )

    result = _PM.run_pf(
        pm,
        model,
        solver,
        setting = Dict("output" => Dict("branch_flows" => true)),
    )
    return result
end

function run_powermodels_opf(json_path)
    # _PM.silence()
    pm = load_pm_from_json(json_path)
    model = get_model(pm["pm_model"])

    solver = get_solver(
        pm["pm_solver"],
        pm["pm_nl_solver"],
        pm["pm_mip_solver"],
        pm["pm_log_level"],
        pm["pm_time_limit"],
        pm["pm_nl_time_limit"],
        pm["pm_mip_time_limit"],
        pm["pm_tol"],
    )


    if haskey(pm["branch"]["1"], "c_rating_a")
        for (key, value) in pm["gen"]
            # value["pmin"] = 0
            value["pmax"] *= 0.01
            value["qmax"] *= 0.01
            value["qmin"] *= 0.01
            value["pg"] *= 0.01
            value["qg"] *= 0.01
            value["cost"] *= 100
        end

        for (key, value) in pm["branch"]
            value["c_rating_a"] *= 0.01
        end

        for (key, value) in pm["load"]
            value["pd"] *= 0.01
            value["qd"] *= 0.01
        end

        result = _PM._run_opf_cl(
            pm,
            model,
            solver,
            setting = Dict("output" => Dict("branch_flows" => true)),
        )
    else
        result = _PM.run_opf(
            pm,
            model,
            solver,
            setting = Dict("output" => Dict("branch_flows" => true)),
        )
    end

    # result["termination_status"] = string(result["termination_status"])
    # result["dual_status"] = string(result["dual_status"])
    # result["primal_status"] = string(result["primal_status"])
    return result
end

function run_powermodels_custom(json_path)
    _PM.silence()
    pm = load_pm_from_json(json_path)
    model = get_model(pm["pm_model"])

    solver = get_solver(
        pm["pm_solver"],
        pm["pm_nl_solver"],
        pm["pm_mip_solver"],
        pm["pm_log_level"],
        pm["pm_time_limit"],
        pm["pm_nl_time_limit"],
        pm["pm_mip_time_limit"],
        pm["pm_tol"],
    )

    result = _PM.run_pf(pm, model, solver)
    # add branch flows
    _PM.update_data!(pm, result["solution"])
    flows = _PM.calc_branch_flow_ac(pm)
    _PM.update_data!(result["solution"], flows)
    return result
end

function run_powermodels_tnep(json_path)
    _PM.silence()
    pm = load_pm_from_json(json_path)
    model = get_model(pm["pm_model"])

    solver = get_solver(
        pm["pm_solver"],
        pm["pm_nl_solver"],
        pm["pm_mip_solver"],
        pm["pm_log_level"],
        pm["pm_time_limit"],
        pm["pm_nl_time_limit"],
        pm["pm_mip_time_limit"],
        pm["pm_tol"],
    )

    result = _PM.run_tnep(
        pm,
        model,
        solver,
        setting = Dict("output" => Dict("branch_flows" => true)),
    )
    return result
end

function run_powermodels_ots(json_path)
    _PM.silence()
    pm = load_pm_from_json(json_path)
    model = get_model(pm["pm_model"])

    solver = get_solver(
        pm["pm_solver"],
        pm["pm_nl_solver"],
        pm["pm_mip_solver"],
        pm["pm_log_level"],
        pm["pm_time_limit"],
        pm["pm_nl_time_limit"],
        pm["pm_mip_time_limit"],
        pm["pm_tol"],
    )

    result = _PM.run_ots(
        pm,
        model,
        solver,
        setting = Dict("output" => Dict("branch_flows" => true)),
    )
    return result
end

function run_pandamodels_vd(json_path)
    _PM.silence()
    pm = load_pm_from_json(json_path)
    model = get_model(pm["pm_model"])

    solver = get_solver(
        pm["pm_solver"],
        pm["pm_nl_solver"],
        pm["pm_mip_solver"],
        pm["pm_log_level"],
        pm["pm_time_limit"],
        pm["pm_nl_time_limit"],
        pm["pm_mip_time_limit"],
        pm["pm_tol"],
    )

    result = _run_vd(
        pm,
        model,
        solver,
        setting = Dict("output" => Dict("branch_flows" => true)),
        ext = extract_params!(pm),
    )
    return result
end
